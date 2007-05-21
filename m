Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbXEUGZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbXEUGZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 02:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbXEUGZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 02:25:48 -0400
Received: from d06184ca.dreamhost.com ([208.97.132.202]:55850 "EHLO
	spaceymail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754370AbXEUGZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 02:25:47 -0400
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] local_softirq_pending storm
Date: Mon, 21 May 2007 11:52:07 +0530
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
References: <200705091942.22920.kernel@prachanda.hub> <200705200253.44992.kernel@prachanda.hub> <1179697388.6570.26.camel@chaos>
In-Reply-To: <1179697388.6570.26.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705211152.08518.kernel@prachanda.hub>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 May 2007 03:13:08 Thomas Gleixner wrote:
> On Sun, 2007-05-20 at 02:53 +0530, Anant Nitya wrote:
> > > 1 == TASK_INTERRUPTIBLE, so we know that ksoftirqd was not woken up. At
> > > least it is not a scheduler problem.
> > >
> > > I work out a more complex debug patch and pester you to test once I'm
> > > done.
> >
> > No problem :)
>
> You asked for it :)
>
> Please patch 2.6.22-rc2 with
>
> http://tglx.de/projects/hrtimers/2.6.22-rc2/patch-2.6.22-rc2-hrt2.patch
> and
> http://www.tglx.de/private/tglx/ht-debug/tracer.diff
>
> Compile it with the config
>
> http://www.tglx.de/private/tglx/ht-debug/config.debug
>
> You should find something like:
>
> (         swapper-0    |#0): new 67173 us user-latency.
>
> along with the familiar "NOHZ ......" message in your log file.
>
> Once that happened please do:
>
> $ cat /proc/latency_trace >trace.txt
>
> compress it and send it to me along with the full dmesg output or put
> both up to some place, where I can download it.
Hi Thomas

Here are the links...
http://cybertek.info/taitai/dmesg-2.6.22.rc2.hrt2-1.SMP.DN.LINUX.txt
http://cybertek.info/taitai/trace.txt.bz2

Regards
Ananitya

>
> Michal,
>
> IIRC you encountered the same P4/HT related wreckage. Can you do the
> same ?
>
> Thanks,
>
> 	tglx



-- 
Out of many thousands, one may endeavor for perfection, and of
those who have achieved perfection, hardly one knows Me in truth.
				-- Gita Sutra Of Mysticism
