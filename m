Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbYDVApL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbYDVApL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 20:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760029AbYDVAo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 20:44:59 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52839 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760006AbYDVAo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 20:44:58 -0400
Date: Mon, 21 Apr 2008 17:44:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, mingo@elte.hu, akpm@linux-foundation.org,
       hch@infradead.org, mmlnx@us.ibm.com, dipankar@in.ibm.com,
       dsmith@redhat.com, rostedt@goodmis.org, adrian.bunk@movial.fi,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, rusty@au1.ibm.com, jkenisto@linux.vnet.ibm.com,
       oleg@tv-sign.ru, jamesclhuang@yahoo.com
Subject: [PATCH 0/5] call_rcu_sched() series
Message-ID: <20080422004454.GA3517@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds call_rcu_sched() and related tracing, applies some
fixes to RCU Classic, adds rcu_barrier_sched(), updates rcutorture,
and updates the RCU documentation.  Drop-in replacement for patches
in http://lkml.org/lkml/2008/4/13/375, but ported to 2.6.25.
