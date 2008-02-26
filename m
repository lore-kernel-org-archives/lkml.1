Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbYBZF1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbYBZF1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 00:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYBZF1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 00:27:45 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:64908 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYBZF1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 00:27:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NAwi0Y3yQwsX1C97GObMgfXffX5ZEY3Ez5sGw2iefriAGvmgDO/O25v6/yg1XSQIHKmj6x/4zoQ1LlDb02Y1X6LLzDsdJqbNguM2IRGjCVvVCwAHSCcivEHxIhN4TPnKa/gxnvGQRXGqHC/y9BJsM1RDSWOvLVxt1KpXx6zNSxc=
Message-ID: <86802c440802252127i36fcd164xe6671aada160766a@mail.gmail.com>
Date: Mon, 25 Feb 2008 21:27:42 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ravikiran Thirumalai" <kiran@scalemp.com>
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box v2
Cc: "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       shai@scalemp.com
In-Reply-To: <20080226040541.GK3143@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802210258.45011.yinghai.lu@sun.com>
	 <200802221102.31019.yinghai.lu@sun.com>
	 <47BF1BD9.4020808@firstfloor.org>
	 <200802232148.43255.yinghai.lu@sun.com>
	 <20080224122903.GC13637@one.firstfloor.org>
	 <20080225190819.GE3143@localdomain>
	 <86802c440802251405w7025a8b2na5fde4dcbf56067e@mail.gmail.com>
	 <20080226033945.GJ3143@localdomain>
	 <20080226034625.GE21577@one.firstfloor.org>
	 <20080226040541.GK3143@localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 8:05 PM, Ravikiran Thirumalai <kiran@scalemp.com> wrote:
> On Tue, Feb 26, 2008 at 04:46:25AM +0100, Andi Kleen wrote:
>  >> I don't quite understand the purpose of the patch to begin with.  Looking at
>  >> the current x86 git tree, apic_is_clustered_box is used only to determine if
>  >> tsc is synchronized on the platform.  The AMD docs  imply that TSC's are not
>  >> guaranteed to be synced across cores between nodes -- Opteron BKDG for
>  >> family 10h, Section 2.9.4:
>  >
>  >After long discussions with AMD they determined the CPUID flag
>  >for sync RDTSC will imply synchronization between nodes.
>
>  Ah!
>
>
>  >
>  >If you can't support that in your hardware you're supposed
>  >to clear it.
>
>  Hmm! How would a hardware vendor do that? That doesn't seem to be clear in
>  the BKDG. (Well, this is the problem with undocumented features :()
>
any good sign for APIC_clustered box? there is apicid between cpus
even all cpu are quadcore and fully populated?

YH
