Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858Ab0A2OeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab0A2OeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 09:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814Ab0A2OeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 09:34:07 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51125 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686Ab0A2OeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 09:34:06 -0500
Date: Fri, 29 Jan 2010 15:34:03 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 00/12] perf lock: New subcommand "perf lock", for
	analyzing lock statistics
Message-ID: <20100129143403.GJ13771@kernel.dk>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22 2010, Hitoshi Mitake wrote:
> Adding new subcommand "perf lock" to perf.
> 
> I made this patch series on
> latest perf/core of tip (ef12a141306c90336a3a10d40213ecd98624d274),
> so please apply this series to perf/core.

[snip]

I wanted to give this a go today, since I think it's pretty nifty and a
lot better than using /proc/lock_stat. But it basically spirals the
system into death [1]. How big a system did you test this on?

[1] Got this: [  117.097918] hrtimer: interrupt took 35093901 ns

-- 
Jens Axboe

