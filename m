Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbZJYMYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbZJYMYv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 08:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZJYMYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 08:24:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbZJYMYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 08:24:49 -0400
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH tip/x86/entry] Fix user return notifier build
Date: Sun, 25 Oct 2009 14:24:45 +0200
Message-Id: <1256473485-23109-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_USER_RETURN_NOTIFIER is set, we need to link
kernel/user-return-notifier.o.

Signed-off-by: Avi Kivity <avi@redhat.com>
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
1.6.4.1

