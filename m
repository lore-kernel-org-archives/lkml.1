Return-Path: <linux-kernel-owner+w=401wt.eu-S1751508AbZKLHjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbZKLHjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbZKLHjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:39:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55939 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbZKLHjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:39:18 -0500
Date: Thu, 12 Nov 2009 08:39:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Measuring term of acquiring spinlock
Message-ID: <20091112073909.GB31719@elte.hu>
References: <20091112.154353.680961628170545165.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112.154353.680961628170545165.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> * Description
> 
> This patch makes the file spinlock_stats on top of the debugfs.
> When user reads this file, some statistical data related to
> spinlocks are printed.

hm, are you aware of the lockstat tracepoints? They do something like 
this - and it utilizes perf events to report these events. See 
include/trace/events/lockdep.h. Needs CONFIG_LOCK_STAT enabled.

Might make sense to put it into 'perf lock' kind of tool. I think 
Frederic had such plans.

	Ingo
