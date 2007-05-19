Return-Path: <linux-kernel-owner+w=401wt.eu-S1764305AbXESTFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764305AbXESTFh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 15:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764161AbXESTFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 15:05:24 -0400
Received: from www.osadl.org ([213.239.205.134]:33338 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763976AbXESTFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 15:05:22 -0400
Subject: Re: [BUG] local_softirq_pending storm
From: Thomas Gleixner <tglx@linutronix.de>
To: Anant Nitya <kernel@prachanda.info>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200705191525.28400.kernel@prachanda.hub>
References: <200705091942.22920.kernel@prachanda.hub>
	 <200705171211.23350.kernel@prachanda.hub> <1179493277.12981.69.camel@chaos>
	 <200705191525.28400.kernel@prachanda.hub>
Content-Type: text/plain
Date: Sat, 19 May 2007 21:11:08 +0200
Message-Id: <1179601868.12981.127.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-19 at 15:25 +0530, Anant Nitya wrote:
> > No idea. I uploaded a debug patch against 2.6.22-rc1 to
> >
> > http://www.tglx.de/private/tglx/2.6.22-rc1-hrt-debug.patch
> >
> > Can you give it a try and report the output ?
> Hi
> Here it goes 
> [  159.646196] NOHZ softirq pending 22 on CPU 0
> [  159.646207] .... task state: 1 00000000

1 == TASK_INTERRUPTIBLE, so we know that ksoftirqd was not woken up. At
least it is not a scheduler problem.

I work out a more complex debug patch and pester you to test once I'm
done.

	tglx



