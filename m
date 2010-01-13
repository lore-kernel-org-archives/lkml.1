Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516Ab0AMK2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0AMK2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464Ab0AMK2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:28:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:58715 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485Ab0AMK2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:28:00 -0500
Date: Wed, 13 Jan 2010 10:27:42 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12626498422334-git-send-email->
References: <12626498422334-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Make MAINTAINERS file match new RCU reality
Message-ID: <tip-f9094d8e5587cf21091a9516628147c0b55e4264@git.kernel.org>
Git-Commit-ID: f9094d8e5587cf21091a9516628147c0b55e4264
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:27:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9094d8e5587cf21091a9516628147c0b55e4264
Gitweb:     http://git.kernel.org/tip/f9094d8e5587cf21091a9516628147c0b55e4264
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 4 Jan 2010 16:04:00 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:06:06 +0100

rcu: Make MAINTAINERS file match new RCU reality

Both rcutorture and RCU are supported.  Also, update the files
to match the new layout.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12626498422334-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 MAINTAINERS |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c8f47bf..175da7c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4509,7 +4509,7 @@ F:	drivers/net/wireless/ray*
 RCUTORTURE MODULE
 M:	Josh Triplett <josh@freedesktop.org>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
-S:	Maintained
+S:	Supported
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcutorture.c
 
@@ -4534,11 +4534,12 @@ M:	Dipankar Sarma <dipankar@in.ibm.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 W:	http://www.rdrop.com/users/paulmck/rclock/
 S:	Supported
-F:	Documentation/RCU/rcu.txt
-F:	Documentation/RCU/rcuref.txt
-F:	include/linux/rcupdate.h
-F:	include/linux/srcu.h
-F:	kernel/rcupdate.c
+F:	Documentation/RCU/
+F:	include/linux/rcu*
+F:	include/linux/srcu*
+F:	kernel/rcu*
+F:	kernel/srcu*
+X:	kernel/rcutorture.c
 
 REAL TIME CLOCK DRIVER
 M:	Paul Gortmaker <p_gortmaker@yahoo.com>
