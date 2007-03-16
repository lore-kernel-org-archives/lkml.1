Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbXCPHus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbXCPHus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932244AbXCPHus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:50:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:35689 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbXCPHur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:50:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hxGI/rr7FjefxfwuM/upB4J27reguzUNDqqhC9cDbTAD/Ba0kLM/mTehK/1y/x9QBbW31JrrYrM3OnJCZcRe4bfMdiyjdJNwK26LBr94dlgumP5bPc2/k8I3iCmZ14BKcbDT+kwx1/jXk+ZhBan63PfYoVu9GXVu6s7dtXq0DhM=
Message-ID: <aec7e5c30703160050w65df9cfaoafd469d1a37bdc4e@mail.gmail.com>
Date: Fri, 16 Mar 2007 16:50:46 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: Horms <horms@verge.net.au>
Subject: Re: [Fastboot] [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
Cc: "Vivek Goyal" <vgoyal@in.ibm.com>, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org,
       "Ian Campbell" <Ian.Campbell@xensource.com>
In-Reply-To: <20070316071031.GB6689@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1173891609.8591.41.camel@localhost.localdomain>
	 <20070315045536.GA6766@in.ibm.com>
	 <20070315050754.GB22329@verge.net.au>
	 <20070315054726.GC6766@in.ibm.com>
	 <1173961378.8591.63.camel@localhost.localdomain>
	 <20070315132616.GH6766@in.ibm.com>
	 <20070315234807.GB10861@verge.net.au>
	 <aec7e5c30703151940x7447abbey80cb6e47250cca58@mail.gmail.com>
	 <20070316032230.GC10515@in.ibm.com>
	 <20070316071031.GB6689@verge.net.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/07, Horms <horms@verge.net.au> wrote:
> On Fri, Mar 16, 2007 at 08:52:30AM +0530, Vivek Goyal wrote:
> > So it will now be left to the user. If he tries to kexec to a 64bit kernel
> > on a machine not supporting 32bit extensions, then kexec will not give
> > any advance warning.
>
> I feel comfortable with that. Well for now anyway.
> But I think that Magnus has other ideas.

I don't mind switching back and forth between 32-bit and 64-bit for
plain kexec, especially if we can validate that the kernel we load
will use an instruction set that is supported. But for kdump,
switching between 32-bit and 64-bit kernels is just another new
dimension in the already too complex kdump matrix IMO.

I think more focus should be put on fixing up bugs in kexec-tools than
adding new features.

/ magnus
