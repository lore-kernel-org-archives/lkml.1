Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab0CJN0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:26:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:53694 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310Ab0CJNZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:25:57 -0500
Date: Wed, 10 Mar 2010 13:25:22 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf, x86: Fix the !CONFIG_CPU_SUP_INTEL build
Message-ID: <tip-caa0142d84ceb0fc83e28f0475d0a7316cb6df77@git.kernel.org>
Git-Commit-ID: caa0142d84ceb0fc83e28f0475d0a7316cb6df77
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:25:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  caa0142d84ceb0fc83e28f0475d0a7316cb6df77
Gitweb:     http://git.kernel.org/tip/caa0142d84ceb0fc83e28f0475d0a7316cb6df77
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 6 Jun 2009 13:58:12 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:40:44 +0100

perf, x86: Fix the !CONFIG_CPU_SUP_INTEL build

Fix typo. But the modularization here is ugly and should be improved.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 1bfd59b..c59678a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -661,7 +661,7 @@ static void intel_ds_init(void)
 
 #else /* CONFIG_CPU_SUP_INTEL */
 
-static int reseve_ds_buffers(void)
+static int reserve_ds_buffers(void)
 {
 	return 0;
 }
