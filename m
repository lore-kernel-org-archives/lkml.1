Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbZKNJ20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbZKNJ20 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 04:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbZKNJ2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 04:28:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:45035 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197AbZKNJ2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 04:28:23 -0500
Date: Sat, 14 Nov 2009 09:27:48 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org, hpa@zytor.com,
       mingo@redhat.com, arjan@linux.intel.com, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, arjan@infradead.org,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091113214733.7cd76be9@infradead.org>
References: <20091113214733.7cd76be9@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_event: Fix invalid type in ioctl definition
Message-ID: <tip-4c49b12853fbb5eff4849b7b6a1e895776f027a1@git.kernel.org>
Git-Commit-ID: 4c49b12853fbb5eff4849b7b6a1e895776f027a1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c49b12853fbb5eff4849b7b6a1e895776f027a1
Gitweb:     http://git.kernel.org/tip/4c49b12853fbb5eff4849b7b6a1e895776f027a1
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Fri, 13 Nov 2009 21:47:33 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 14 Nov 2009 10:23:52 +0100

perf_event: Fix invalid type in ioctl definition

u64 is invalid in userspace headers, including ioctl
definitions; use __u64 instead

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: <stable@kernel.org>
LKML-Reference: <20091113214733.7cd76be9@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 45b56fa..ec3768a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -219,7 +219,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_DISABLE		_IO ('$', 1)
 #define PERF_EVENT_IOC_REFRESH		_IO ('$', 2)
 #define PERF_EVENT_IOC_RESET		_IO ('$', 3)
-#define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, u64)
+#define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, __u64)
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
 
