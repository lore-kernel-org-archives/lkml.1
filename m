Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbXCZRuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbXCZRuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 13:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbXCZRuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 13:50:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:28466 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbXCZRun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 13:50:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NsDbXHnJnEU8mX2Yol3PL6Rh9leRBk6SNI99GIaSCeXYmEOBUUB+zQeeAUMe+io95Xwek8IYXQ/zEdBC6v0kmcbSZccNnyEYQENU0IEUQngFExAZujnxo1VB5/jRYfPGl5pJCjEHtQGFZVvQnCnjWsQy+Viayysm+8EWIk9behw=
Message-ID: <6bffcb0e0703261050i7e89607fo32f825b79821e5ea@mail.gmail.com>
Date: Mon, 26 Mar 2007 19:50:41 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] hrtimers debug patch
Cc: "Nick Piggin" <npiggin@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Mingming Cao" <cmm@us.ibm.com>, "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       "Oliver Pinter" <oliver.pntr@gmail.com>,
       "Sid Boyce" <g3vbv@blueyonder.co.uk>,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <20070326170225.GA951@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070318184908.GU752@stusta.de> <46020385.50301@yahoo.com.au>
	 <Pine.LNX.4.64.0703220813340.6730@woody.linux-foundation.org>
	 <1174612132.16068.114.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org>
	 <20070323021115.GA11147@wotan.suse.de>
	 <6bffcb0e0703230051i5accb180r7bd0fb16de85198a@mail.gmail.com>
	 <20070323120148.GA27505@elte.hu> <4607BDD9.1010002@googlemail.com>
	 <20070326170225.GA951@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/03/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>
> > Stardust is down, console log and config attached.
>
> thanks! I have stared at hrtimer.c a few more hours and the good news is
> that i found a narrow SMP race. The bad news is that i dont think it
> could explain your bug symptoms: the worst-case effect of the race
> should be an incorrect timeout on the current CPU - not a KTIME_MAX
> thing like your logs show.
>
> But maybe i didnt think through the effects of the bug well enough, and
> your box has a HT CPU, with HT CPUs being pretty good at triggering
> narrow SMP races - so maybe we are lucky? Fix attached below. Patch is
> build and boot-tested.

Thanks. Verification may take some time.

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
