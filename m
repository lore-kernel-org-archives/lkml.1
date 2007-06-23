Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbXFWR0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbXFWR0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 13:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbXFWR0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 13:26:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40577 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438AbXFWR0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 13:26:05 -0400
Date: Sat, 23 Jun 2007 19:25:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Antonino Ingargiola <tritemio@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070623172557.GA27435@elte.hu>
References: <20070622220202.GA16872@elte.hu> <5486cca80706230322k6e3c0f81u8e3d149ca04dc041@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5486cca80706230322k6e3c0f81u8e3d149ca04dc041@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.6
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.6 required=5.9 tests=BAYES_00,UPPERCASE_25_50 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.4 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Antonino Ingargiola <tritemio@gmail.com> wrote:

> 2007/6/23, Ingo Molnar <mingo@elte.hu>:
> >
> >i'm pleased to announce release -v18 of the CFS scheduler patchset.
> 
> I'm running -v18 on 2.6.22-rc5, no problems so far. How can I change a 
> task to SCHED_IDLE or SCHED_BATCH priority under CFS?

pick up schedtool, and these are the choices it gives:

    -N                    for SCHED_NORMAL
    -F -p PRIO            for SCHED_FIFO       only as root
    -R -p PRIO            for SCHED_RR         only as root
    -B                    for SCHED_BATCH
    -I -p PRIO            for SCHED_ISO
    -D                    for SCHED_IDLEPRIO

then for example to start up something as SCHED_IDLE:

  schedtool -D -e ./somecommand.sh

	Ingo
