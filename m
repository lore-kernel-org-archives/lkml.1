Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbZKPMT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbZKPMT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbZKPMTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:19:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbZKPMTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:39 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 02/42] x86: Fix user return notifier build
Date: Mon, 16 Nov 2009 14:19:03 +0200
Message-Id: <1258373983-8693-3-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
-- 
1.6.5.2

