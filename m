Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbYBSKjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbYBSKjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYBSKjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:39:37 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:36382 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbYBSKjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:39:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UdndVHmP/dWpREJ7NnBqhAmAN8ykNmJjGmWpVQWTpFTzgQYJdi/txIiJR94qwHt+zjbMwT3+QxTa8woUaAQgkc+Luc7W/cK7V4JeMPd7BCX+mJ5NIq14ASZ/ujRr08BeVN/X4t1/27JSeljsXAnguz8LYp/QeX/aHasS9y06gk0=
Message-ID: <86802c440802190239p3e105842lb8c069c111f1f9a4@mail.gmail.com>
Date: Tue, 19 Feb 2008 02:39:33 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 4/5] x86_64: check msr to get mmconfig for amd family 10h opteron v3
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Greg KH" <greg@kroah.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080219101335.GB14092@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802150127.21247.yinghai.lu@sun.com>
	 <200802150128.41638.yinghai.lu@sun.com>
	 <200802150130.14915.yinghai.lu@sun.com>
	 <200802150131.16816.yinghai.lu@sun.com>
	 <86802c440802181959t762bc242n79d2f0d93b224f31@mail.gmail.com>
	 <20080219101335.GB14092@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 2:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> > > Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
> > > ===================================================================
> > > --- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
> > > +++ linux-2.6/arch/x86/pci/mmconfig-shared.c
> >
> > Ingo/Thomas,
> >
> > It seems you missed this one in the 5.
> >
> > this one should be safe. it only reads msr.
>
> we picked up all of your patches - have you checked the x86.git#testing
> branch, or only the x86.git#mm branch? We started x86.git#testing
> recently, it includes more bleeding-edge stuff and wider, cross-tree
> features as well.
>
> > Andi had concern with other one that was touching msr. I will keep
> > that one in my local tree.
>
> We've got that one queued up in x86.git#testing as well. Someone on lkml
> having concerns is not a basis to not deal with a patch. What matters
> is: are those concerns well-founded? If you do not agree with the
> concerns then just indicate it to us when re-submitting but do not drop
> patches. Your patches have a good track record so please do not let
> yourself get scared away from contributing. Please do not keep patches
> in your local tree, we'd like Linux to work fine out of box, on as broad
> range of hardware as possible.

good, I will send out the left over according to testing.

YH
