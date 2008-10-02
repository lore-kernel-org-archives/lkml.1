Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbYJBTA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbYJBTA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYJBTAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:00:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:30166 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbYJBTAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:00:14 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, srostedt@redhat.com,
       Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH -tip] ftrace: ktime.h not included in ftrace.h
Date: Thu,  2 Oct 2008 12:00:07 -0700
Message-Id: <1222974007-3745-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including <linux/ktime.h> eliminates the following error:

include/linux/ftrace.h:220: error: expected specifier-qualifier-list
before 'ktime_t'

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 include/linux/ftrace.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index deded11..ed53265 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -3,6 +3,7 @@
 
 #include <linux/linkage.h>
 #include <linux/fs.h>
+#include <linux/ktime.h>
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/kallsyms.h>
-- 
1.6.0.2

