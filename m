Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934680Ab0CLXIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 18:08:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:58769 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933445Ab0CLXIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 18:08:20 -0500
Date: Fri, 12 Mar 2010 23:06:36 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1268434560-2677-1-git-send-email-johnstul@us.ibm.com>
References: <1268434560-2677-1-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time: Add xtime, wall_to_monotonic to feature-removal-schedule
Message-ID: <tip-25268498c9e07870323aead10751b7c6e99a3a78@git.kernel.org>
Git-Commit-ID: 25268498c9e07870323aead10751b7c6e99a3a78
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Mar 2010 23:06:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25268498c9e07870323aead10751b7c6e99a3a78
Gitweb:     http://git.kernel.org/tip/25268498c9e07870323aead10751b7c6e99a3a78
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Fri, 12 Mar 2010 14:56:00 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 13 Mar 2010 00:05:14 +0100

time: Add xtime, wall_to_monotonic to feature-removal-schedule

They aren't really features, but fair warning to out of tree
driver folks who might be accessing these variables.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <1268434560-2677-1-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/feature-removal-schedule.txt |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index a5cc0db..198acdc 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -582,3 +582,13 @@ Why:	The paravirt mmu host support is slower than non-paravirt mmu, both
 Who:	Avi Kivity <avi@redhat.com>
 
 ----------------------------
+
+What:	xtime, wall_to_monotonic
+When:	2.6.36+
+Files:	kernel/time/timekeeping.c include/linux/time.h
+Why:	Cleaning up timekeeping internal values. Please use
+	existing timekeeping accessor functions to access
+	the equivalent functionality.
+Who:	John Stultz <johnstul@us.ibm.com>
+
+----------------------------
