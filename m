Return-Path: <linux-kernel-owner+w=401wt.eu-S1422688AbXCWIRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422688AbXCWIRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 04:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422692AbXCWIRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 04:17:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:38082 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422688AbXCWIRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 04:17:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pw+7pS3GUhaja8Qhbp9lx/+WFEmTYcbim0isdR3pee159hoc7MCdQzHLpFy1vSJl8dCF/Hdf7w7BCTDBsbtkjG6tY7RL9xe5oulCVaSNQM2dRAMdQapsd+QqOvsZBr4GKBtQ1B8EW3gRZmijGNkmpSos+ms9+DHWUe6yDQvBn7g=
Message-ID: <6bffcb0e0703230117i5b01d13frc2d7798276e70bab@mail.gmail.com>
Date: Fri, 23 Mar 2007 09:17:34 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.21-rc4-rt0-kdump (was: Re: [patch] setup_boot_APIC_clock() irq-enable fix)
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070323080252.GA11668@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0703211338i2aa6f933ube53c6604c78e285@mail.gmail.com>
	 <20070322093119.GA19394@elte.hu>
	 <6bffcb0e0703220557h7ff64282qf378623452c07d03@mail.gmail.com>
	 <4602843D.9000306@googlemail.com> <20070323071502.GA2090@elte.hu>
	 <6bffcb0e0703230058i6ec926cch76b86f47eb0e5383@mail.gmail.com>
	 <20070323080252.GA11668@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/03/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>
> > >> Hibernation is still broken.
> > >>
> > >>
> > >http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4-rt0/console.log
> > >>
> > >http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4-rt0/rt-config
> > >
> > >what's the failure mode besides the lockdep + other debug messages -
> > >it doesnt resume? Your log seems to have at least one sequence of
> > >resume related messages - those seem to have worked fine.
> >
> > Kernel has crashed after
>
> crashed == 'hung hard' or 'spontaneous reboot' or 'other'?

It means 'nothing has happened for a five minutes'.

>
> > Read 497936 kbytes in 23.09 seconds (21.56 MB/s)
> > swsusp: Reading resume file was successful
> > PM: Preparing devices for restore.
> > Suspending console(s)
>
> i havent used sw-suspend for a while, so here's a stupid question: why
> does it try to suspend the consoles in the resume path? I assume the
> messages above mean that we are already in the resume path?

Yes. (I'm not sure, but "Suspending console(s)" might come from PM_DEBUG.)

>
>         Ingo
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
