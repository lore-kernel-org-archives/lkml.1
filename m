Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbZIOTPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbZIOTPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758595AbZIOTPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:15:40 -0400
Received: from kroah.org ([198.145.64.141]:43838 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758527AbZIOTPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:15:14 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: GeunSik Lim <leemgs1@gmail.com>, GeunSik Lim <geunsik.lim@samsung.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/20] debugfs: Change debuhgfs directory of trace-events-sample.h
Date: Tue, 15 Sep 2009 12:12:52 -0700
Message-Id: <1253041976-1111-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090915181247.GA32167@kroah.com>
References: <20090915181247.GA32167@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GeunSik Lim <leemgs1@gmail.com>

Default directory of debug filesystem for ftrace is /sys/kernel/debug/.

Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 samples/trace_events/trace-events-sample.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index f24ae37..6af3732 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -1,6 +1,6 @@
 /*
  * If TRACE_SYSTEM is defined, that will be the directory created
- * in the ftrace directory under /debugfs/tracing/events/<system>
+ * in the ftrace directory under /sys/kernel/debug/tracing/events/<system>
  *
  * The define_trace.h below will also look for a file name of
  * TRACE_SYSTEM.h where TRACE_SYSTEM is what is defined here.
-- 
1.6.4.2

