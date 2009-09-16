Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbZIPKW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbZIPKW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758616AbZIPKWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:22:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:46479 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757172AbZIPKWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:22:22 -0400
Date: Wed, 16 Sep 2009 10:21:56 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix some domain tunings
Message-ID: <tip-6bd7821f905a8d6c471f0d6675f5cb7ea448d791@git.kernel.org>
Git-Commit-ID: 6bd7821f905a8d6c471f0d6675f5cb7ea448d791
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:21:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6bd7821f905a8d6c471f0d6675f5cb7ea448d791
Gitweb:     http://git.kernel.org/tip/6bd7821f905a8d6c471f0d6675f5cb7ea448d791
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 11 Sep 2009 18:42:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:01:08 +0200

sched: Fix some domain tunings

CPU level should have WAKE_AFFINE, whereas ALLNODES is dubious.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/topology.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index fef5704..c87edcd 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -160,7 +160,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
 				| 1*SD_BALANCE_WAKE			\
-				| 0*SD_WAKE_AFFINE			\
+				| 1*SD_WAKE_AFFINE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
@@ -186,7 +186,7 @@ int arch_update_cpu_topology(void);
 				| 0*SD_BALANCE_EXEC			\
 				| 0*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
-				| 1*SD_WAKE_AFFINE			\
+				| 0*SD_WAKE_AFFINE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 0*SD_SHARE_PKG_RESOURCES		\
