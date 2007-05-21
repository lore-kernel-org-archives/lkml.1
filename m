Return-Path: <linux-kernel-owner+w=401wt.eu-S934812AbXEUT57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934812AbXEUT57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765299AbXEUTkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:40:35 -0400
Received: from d0618453.dreamhost.com ([208.97.132.83]:34538 "EHLO
	spaceymail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934482AbXEUTkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:40:33 -0400
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] local_softirq_pending storm
Date: Tue, 22 May 2007 00:15:43 +0530
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
References: <200705091942.22920.kernel@prachanda.hub> <200705211152.08518.kernel@prachanda.hub> <1179738117.6570.37.camel@chaos>
In-Reply-To: <1179738117.6570.37.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705220015.44891.kernel@prachanda.hub>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 May 2007 14:31:57 Thomas Gleixner wrote:
> On Mon, 2007-05-21 at 11:52 +0530, Anant Nitya wrote:
> > > You should find something like:
> > >
> > > (         swapper-0    |#0): new 67173 us user-latency.
> > >
> > > along with the familiar "NOHZ ......" message in your log file.
> > >
> > > Once that happened please do:
> > >
> > > $ cat /proc/latency_trace >trace.txt
> > >
> > > compress it and send it to me along with the full dmesg output or put
> > > both up to some place, where I can download it.
> >
> > Hi Thomas
> >
> > Here are the links...
> > http://cybertek.info/taitai/dmesg-2.6.22.rc2.hrt2-1.SMP.DN.LINUX.txt
> > http://cybertek.info/taitai/trace.txt.bz2
>
> Thanks. Sorry, I need more info. I uploaded a new tracer.diff to
>
> http://www.tglx.de/private/tglx/ht-debug/tracer.diff
>
> Can you please revert the first one and retest with the new one ?
>
> Thanks,
Sorry for delay, here is link for output from new tacer.
http://cybertek.info/taitai/trace-new.txt.bz2

Regards
Ananitya

>
> 	tglx



-- 
Out of many thousands, one may endeavor for perfection, and of
those who have achieved perfection, hardly one knows Me in truth.
				-- Gita Sutra Of Mysticism
