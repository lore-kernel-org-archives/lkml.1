Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0BANXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 08:23:13 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49139 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab0BANXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 08:23:11 -0500
Date: Mon, 1 Feb 2010 14:23:09 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 00/12] perf lock: New subcommand "perf lock", for
	analyzing  lock statistics
Message-ID: <20100201132309.GM13771@kernel.dk>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100129143403.GJ13771@kernel.dk> <4B641F4D.6090704@dcl.info.waseda.ac.jp> <20100131204408.GC13771@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100131204408.GC13771@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31 2010, Jens Axboe wrote:
> > I tested this on Core i7 965 + 3GB DRAM machine.
> > Test program is mainly "perf bench sched messaging".
> >
> > Could you tell me the detail of your test situation?
> 
> I tried to run it on a 64 thread box, on a fio job that was driving 80
> disks. It was just a quick test, but after ~20 seconds it had not even
> gotten started yet, it was still stuck in setting up the jobs and
> traversing sysfs for finding disk stats, etc. I can try something
> lighter to see if it's the cpu count or the tough job that was making it
> spiral into (near) death.

A simple 'perf lock rec ls' exhibits the same symptoms. It's been
running for a minute or so now, no output. Even local network pings take
500-1000ms.

-- 
Jens Axboe

