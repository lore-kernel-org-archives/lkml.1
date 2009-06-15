Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbZFOInU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbZFOInU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZFOInN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:43:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54136 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbZFOInM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:43:12 -0400
Date: Mon, 15 Jun 2009 10:36:40 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/2] posix-cpu-timers: random fixes rework -v3
Message-ID: <20090615103640.4b828cc4@dhcp-lab-109.englab.brq.redhat.com>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two fixes related with posix-cpu-timers

Changes in -v3:
patch 2 - use has_has_group_leader_pid() instated of thread_group_leader()

Changes in -v2:
patch 1 - add more exact description what happens 
patch 2 - fix bug where rcu_read_lock() was used instead of rcu_read_unlock()

Cheers
Satanislaw

