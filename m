Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZKBKOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZKBKOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbZKBKOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:14:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:47853 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937AbZKBKOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:14:03 -0500
Date: Mon, 2 Nov 2009 10:12:48 GMT
From: tip-bot for Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, avi@redhat.com, mingo@elte.hu
In-Reply-To: <1256473485-23109-1-git-send-email-avi@redhat.com>
References: <1256473485-23109-1-git-send-email-avi@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/entry] x86: Fix user return notifier build
Message-ID: <tip-7a041097518a120f92af631a83db4d41e07ee51b@git.kernel.org>
Git-Commit-ID: 7a041097518a120f92af631a83db4d41e07ee51b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a041097518a120f92af631a83db4d41e07ee51b
Gitweb:     http://git.kernel.org/tip/7a041097518a120f92af631a83db4d41e07ee51b
Author:     Avi Kivity <avi@redhat.com>
AuthorDate: Sun, 25 Oct 2009 14:24:45 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 25 Oct 2009 17:37:57 +0100

x86: Fix user return notifier build

When CONFIG_USER_RETURN_NOTIFIER is set, we need to link
kernel/user-return-notifier.o.

Signed-off-by: Avi Kivity <avi@redhat.com>
LKML-Reference: <1256473485-23109-1-git-send-email-avi@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index b8d4cd8..0ae57a8 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -95,6 +95,7 @@ obj-$(CONFIG_RING_BUFFER) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_SLOW_WORK) += slow-work.o
 obj-$(CONFIG_PERF_EVENTS) += perf_event.o
+obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
