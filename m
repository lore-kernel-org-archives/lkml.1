Return-Path: <linux-kernel-owner+w=401wt.eu-S968835AbXG3Ver@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968835AbXG3Ver (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967980AbXG3Veg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:34:36 -0400
Received: from cb2.northrockquote.com ([64.251.14.146]:1917 "EHLO
	dejavu.debianpt.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S967671AbXG3Vee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:34:34 -0400
From: Miguel Figueiredo <elmig@debianpt.org>
Organization: DebianPT.org
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Date: Mon, 30 Jul 2007 22:34:21 +0100
User-Agent: KMail/1.9.5
Cc: Kenneth Prugh <ken69267@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070730191029.GA29327@elte.hu> <46AE570B.3050802@gmail.com>
In-Reply-To: <46AE570B.3050802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707302234.21860.elmig@debianpt.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Segunda, 30 de Julho de 2007 22:24, Kenneth Prugh escreveu:
> Ingo Molnar wrote:
> > * Kenneth Prugh <ken69267@gmail.com> wrote:
> >> Ingo Molnar wrote:
> >>> <large snip>
> >>
> >> Hello, I have a gaming rig and would love to help benchmark with my
> >> copy of UT2004(E6600 Core2 and a 7950GTO card). Or if you have
> >> anything else that would better serve as a benchmark I could grab it
> >> and try.
> >>
> >> The only problem is I don't know what 2 kernels I should be using to
> >> test the schedulers. I assume 2.6.23-rc1 for CFS, but what about SD?
> >
> > .22-ck1 includes it, so that should be fine:
> >
> >  http://ussg.iu.edu/hypermail/linux/kernel/0707.1/0318.html
> >
> > 	Ingo
>
> Alright, Just got done with some testing of UT2004 between 2.6.23-rc1
> CFS and 2.6.22-ck1 SD. This series of tests was run by spawning in a map
> while not moving at all and always facing the same direction, while
> slowing increasing the number of loops.
>
> CFS generally seemed a lot smoother as the load increased, while SD
> broke down to a highly unstable fps count that fluctuated massively
> around the third loop. Seems like I will stick to CFS for gaming now.
>
> Below you will find the results of my test with the average number of FPS.
>
> 		CFS		|		SD
> UT2004 + 0 loops | 200 FPS		UT2004 + 0 loops | 190 FPS
> UT2004 + 1 loops | 195 FPS		UT2004 + 1 loops | 190 FPS
> UT2004 + 2 loops | 190 FPS		UT2004 + 2 loops | 190 FPS
> UT2004 + 3 loops | 189 FPS		UT2004 + 3 loops | 136 FPS
> UT2004 + 4 loops | 150 FPS		UT2004 + 4 loops | 137 FPS
> UT2004 + 5 loops | 145 FPS		UT2004 + 5 loops | 136 FPS
> UT2004 + 6 loops | 145 FPS		UT2004 + 6 loops | 105 FPS
> UT2004 + 7 loops | 118 FPS		UT2004 + 7 loops | 104 FPS
> UT2004 + 8 loops | 97 FPS		UT2004 + 8 loops | 104 FPS
> UT2004 + 9 loops | 94 FPS		UT2004 + 9 loops | 89 FPS
> UT2004 + 10 loops | 92 FPS		UT2004 + 10 loops | 91 FPS

can you apply the patch [1] that changes the behaviour of sched_yield on SD 
and report the results?

SD should scale a lot better after the patch.

1 - http://bhhdoa.org.au/pipermail/ck/2007-July/008297.html

-- 

Com os melhores cumprimentos/Best regards,

Miguel Figueiredo
http://www.DebianPT.org
