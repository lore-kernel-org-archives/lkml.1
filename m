Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbZKMEV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbZKMEV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 23:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbZKMEVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 23:21:22 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50348 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbZKMEVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 23:21:21 -0500
Date: Fri, 13 Nov 2009 13:21:25 +0900 (JST)
Message-Id: <20091113.132125.468378199533086916.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, tglx@linutronix.de, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Measuring term of acquiring spinlock
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091112073909.GB31719@elte.hu>
References: <20091112.154353.680961628170545165.mitake@dcl.info.waseda.ac.jp>
	<20091112073909.GB31719@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RFC] Measuring term of acquiring spinlock
Date: Thu, 12 Nov 2009 08:39:09 +0100

> 
> * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> 
> > * Description
> > 
> > This patch makes the file spinlock_stats on top of the debugfs.
> > When user reads this file, some statistical data related to
> > spinlocks are printed.
> 
> hm, are you aware of the lockstat tracepoints? They do something like 
> this - and it utilizes perf events to report these events. See 
> include/trace/events/lockdep.h. Needs CONFIG_LOCK_STAT enabled.
>

Wow, I didn't know that. I'll try it.

> Might make sense to put it into 'perf lock' kind of tool. I think 
> Frederic had such plans.

If you want a tester for 'perf lock', please call me, Frederic :)
