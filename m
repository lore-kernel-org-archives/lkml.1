Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbZHXQlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbZHXQlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZHXQlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:41:16 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41049 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbZHXQlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:41:15 -0400
Date: Mon, 24 Aug 2009 09:41:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: [PATCH -tip 0/2] Temporary RCU fixes for notrace and hotplug CPU
Message-ID: <20090824164112.GA13693@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds a couple of needed "notrace" declarations and one
of two needed CPU-hotplug rcutree plugins.  This applies on top of
current tip/core/rcu, but is a temporary fix.  The problem with it is
that it is not bisectable when using ftrace.

This will be replaced with a later rework of the tip/core/rcu patch
stack.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/rcupdate.h |    5 ++---
 kernel/rcutree.c         |    2 ++
 kernel/rcutree_plugin.h  |   25 ++++++++++++++++++++++++-
 3 files changed, 28 insertions(+), 4 deletions(-)
