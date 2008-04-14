Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbYDND7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbYDND7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 23:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbYDND64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 23:58:56 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40848 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbYDND64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 23:58:56 -0400
Date: Sun, 13 Apr 2008 20:58:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, mingo@elte.hu, akpm@linux-foundation.org,
       hch@infradead.org, mmlnx@us.ibm.com, dipankar@in.ibm.com,
       dsmith@redhat.com, rostedt@goodmis.org, adrian.bunk@movial.fi,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, rusty@au1.ibm.com, jkenisto@linux.vnet.ibm.com,
       oleg@tv-sign.ru, jamesclhuang@yahoo.com
Subject: [PATCH 0/5] call_rcu_sched() series
Message-ID: <20080414035848.GA30005@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds call_rcu_sched(), applies some fixes to RCU Classic,
adds rcu_barrier_sched(), updates rcutorture, and updates the RCU
documentation.
