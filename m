Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbZLIJmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbZLIJmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZLIJmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:42:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbZLIJmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:42:24 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC PATCH 0/6] cpu-timers patches
Date: Wed,  9 Dec 2009 10:39:52 +0100
Message-Id: <1260351598-4203-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are patches for cpu-timers I mainly wrote to not call 
thread_group_cputime() in fastpath_timer_check(), which we
discuss in this thread:

http://thread.gmane.org/gmane.linux.kernel/909349/focus=912327
  
On the way I fix some other bugs (SIGEV_NONE timer, old increase value
in timer_settime()) and do other cleanups and optimizations, patch 3
however increase time when sighand->siglock is held. 

0001-cpu-timers-simplify-RLIMIT_CPU-handling.patch
0002-cpu-timers-cleanup-arm_timer.patch
0003-cpu-timers-return-true-old-increase-value-in-timer_.patch
0004-cpu-timers-change-SIGEV_NONE-timer-handling.patch
0005-cpu-timer-change-arm_timer-locking.patch
0006-cpu-timers-optimize-run_posix_cpu_timers.patch

Cheers
Stanislaw

