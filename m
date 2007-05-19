Return-Path: <linux-kernel-owner+w=401wt.eu-S1764411AbXESVYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764411AbXESVYP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 17:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbXESVYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 17:24:00 -0400
Received: from balanced.mail.policyd.dreamhost.com ([208.97.132.119]:60468
	"EHLO spaceymail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754749AbXESVX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 17:23:59 -0400
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] local_softirq_pending storm
Date: Sun, 20 May 2007 02:53:44 +0530
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
References: <200705091942.22920.kernel@prachanda.hub> <200705191525.28400.kernel@prachanda.hub> <1179601868.12981.127.camel@chaos>
In-Reply-To: <1179601868.12981.127.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705200253.44992.kernel@prachanda.hub>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 May 2007 00:41:08 Thomas Gleixner wrote:
> On Sat, 2007-05-19 at 15:25 +0530, Anant Nitya wrote:
> > > No idea. I uploaded a debug patch against 2.6.22-rc1 to
> > >
> > > http://www.tglx.de/private/tglx/2.6.22-rc1-hrt-debug.patch
> > >
> > > Can you give it a try and report the output ?
> >
> > Hi
> > Here it goes
> > [  159.646196] NOHZ softirq pending 22 on CPU 0
> > [  159.646207] .... task state: 1 00000000
>
> 1 == TASK_INTERRUPTIBLE, so we know that ksoftirqd was not woken up. At
> least it is not a scheduler problem.
>
> I work out a more complex debug patch and pester you to test once I'm
> done.
No problem :)

Regards
Ananitya

>
> 	tglx



-- 
Out of many thousands, one may endeavor for perfection, and of
those who have achieved perfection, hardly one knows Me in truth.
				-- Gita Sutra Of Mysticism
