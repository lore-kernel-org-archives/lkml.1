Return-Path: <linux-kernel-owner+w=401wt.eu-S1763850AbYBZVJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763850AbYBZVJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbYBZVJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:09:15 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:21723 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbYBZVJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:09:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kVOVmL+l76v/V77b07YOcv6MSu3Q/74+o5M6eaVT3GmxlPcNK2BjO0wagIxv2lNfrDoAk/epk7yQ45qlHTfOGVou4mxD2UEGacMST37DVabE5vhQ9F/c7vtvNtgXZj3Ic+5aFsXC8/udnGTRhJbeSC9gMQaBq4gdSXoiN4Z2p7E=
Message-ID: <86802c440802261309g67fab67eka19db3b02b068a39@mail.gmail.com>
Date: Tue, 26 Feb 2008 13:09:11 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ravikiran Thirumalai" <kiran@scalemp.com>
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box v2
Cc: "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       shai@scalemp.com
In-Reply-To: <20080226203235.GH5914@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802232148.43255.yinghai.lu@sun.com>
	 <20080225190819.GE3143@localdomain>
	 <86802c440802251405w7025a8b2na5fde4dcbf56067e@mail.gmail.com>
	 <20080226033945.GJ3143@localdomain>
	 <20080226034625.GE21577@one.firstfloor.org>
	 <20080226040541.GK3143@localdomain>
	 <86802c440802252127i36fcd164xe6671aada160766a@mail.gmail.com>
	 <20080226184235.GA5914@localdomain>
	 <86802c440802261100j322ee6a6yef9108dc175de459@mail.gmail.com>
	 <20080226203235.GH5914@localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 12:32 PM, Ravikiran Thirumalai
<kiran@scalemp.com> wrote:
> On Tue, Feb 26, 2008 at 11:00:58AM -0800, Yinghai Lu wrote:
>  >
>  >1. if acpi=off ?
>
>  Well that is not a realistic scenario for any multi chassi NUMA machine,
>  since the proximity information is very important and turning acpi off
>  deprives the OS of this information.
>
>
>  >2. some system will be treated wrong.
>  >my four sockets system
>  >ACPI: SLIT: nodes = 4
>  > 10 13 13 16
>  > 13 10 16 13
>  > 13 16 10 13
>  > 16 13 13 10
>  >my eight sockets system
>
>  This makes it difficult to use SLIT for multi chassi detection then :(.
>  Did not know such SLIT tables existed on single board machines.
Yes

YH
