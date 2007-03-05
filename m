Return-Path: <linux-kernel-owner+w=401wt.eu-S933188AbXCELra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbXCELra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 06:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933193AbXCELr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 06:47:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:53070 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933188AbXCELr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 06:47:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TGQbznmFOOiy2lfINA8YNhRPY9yKtJBAmk2yrZh/eJ4XuSsN5UrtA0j4dPoBbilTDmTv9wiIZ566PYRPs3DqjT8Q2zR+DDMTIrNuSMIIwR2azf1a2lIs6NA1oX39ZplyClxnyiwmKcm7LTN/bf4Qls8bupfRGItU3HoI8KS31KE=
Message-ID: <6bffcb0e0703050347j5169c672g19996d5c76707123@mail.gmail.com>
Date: Mon, 5 Mar 2007 12:47:26 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.21-rc2-git3 soft lockup detected on CPU#0 (crash dump kernel)
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070305103141.GA18404@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1173018209.24738.135.camel@localhost.localdomain>
	 <1173022668.24738.141.camel@localhost.localdomain>
	 <6bffcb0e0703040828j46a339c2ofabf7c0e20f6ae09@mail.gmail.com>
	 <1173026442.24738.143.camel@localhost.localdomain>
	 <6bffcb0e0703040847g1c04940bm4c22895ec2540bd1@mail.gmail.com>
	 <1173027823.24738.156.camel@localhost.localdomain>
	 <6bffcb0e0703040915h442b4d6cq8bb47cd961165916@mail.gmail.com>
	 <20070305080824.GA20583@elte.hu>
	 <1173090869.24738.198.camel@localhost.localdomain>
	 <20070305103141.GA18404@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Thomas Gleixner <tglx@linutronix.de> wrote:
>
> > > shouldnt that be 'R' instead of the question mark?
> >
> > ? are dead ones,
>
> ok.
>
> > The interesting part is here:
> >
> > 1 lock held by udevd/918:
> >  #0:  (&mm->mmap_sem){----}, at: [<c161135b>] do_page_fault+0x150/0x50d
> >
> > But udevd/918 is nowhere in the sysrq-t output.
>
> also below is a softlockup-debug patch that might be useful, which adds
> a tick/tock output so it spams the console once per second but can show
> the dynamics of lockups (and other delays).

I have applied this patch
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc2-git3-kdump/log3.txt

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
