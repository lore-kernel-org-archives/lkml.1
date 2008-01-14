Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbYANKux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbYANKux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 05:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYANKup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 05:50:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:18277 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbYANKuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 05:50:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=i1gG77WclJUkBDkzgp/PAHXIQihf8zygUH/m+7NEOJrHntKl1m4tW2QXTA17qQvQHGOVPt2s7nhbY2pFXDFyOqrudgGfzJ8pvrLN7ARAkmWnfeO7kY3196drkflEPeSADDNCdXgWpZhcp2q002aMZwLqRHN6jVyCyEqegi5c/aw=
Subject: [PATCH] Re-organization of PIDMAP_ENTRIES macro expansion
From: Ratnadeep Joshi <ratn.josh@gmail.com>
Reply-To: ratn.josh@gmail.com
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, akpm@linux-foundation.org
Content-Type: text/plain
Date: Mon, 14 Jan 2008 16:20:35 +0530
Message-Id: <1200307835.2819.18.camel@life.india.kernelcorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to re-organize the macro expansion of PIDMAP_ENTRIES
(possibly) to a more clear one.

Thanks,
- Ratnadeep Joshi

diff --git a/include/linux/pid_namespace.h
b/include/linux/pid_namespace.h
index 1689e28..06e3e99 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -12,7 +12,7 @@ struct pidmap {
        void *page;
 };
 
-#define PIDMAP_ENTRIES         ((PID_MAX_LIMIT + 8*PAGE_SIZE -
1)/PAGE_SIZE/8)
+#define PIDMAP_ENTRIES         ((PID_MAX_LIMIT - 1)/PAGE_SIZE/8 + 1)
 
 struct pid_namespace {
 	struct kref kref;


