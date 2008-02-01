Return-Path: <linux-kernel-owner+w=401wt.eu-S935908AbYBAE5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935908AbYBAE5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbYBAEnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:43:17 -0500
Received: from mga10.intel.com ([192.55.52.92]:64964 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752201AbYBAEly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:41:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511516578"
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [PATCH 15/37] Suspend: Fix compilation warning for CONFIG_SUSPEND unset
Date: Thu, 31 Jan 2008 23:36:46 -0500
Message-Id: <2006b470bbc77e4d6b46a7bbb5b68119e1a8db3f.1201840183.git.len.brown@intel.com>
X-Mailer: git-send-email 1.5.4.rc5.16.gc0279
In-Reply-To: <1201840628-23136-1-git-send-email-lenb@kernel.org>
References: <1201840628-23136-1-git-send-email-lenb@kernel.org>
In-Reply-To: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
References: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Suspend: Make debug facility depend on CONFIG_SUSPEND

Make the new suspend debug facility code depend on CONFIG_SUSPEND,
as appropriate, to remove the compiler warning printed when CONFIG_PM is set
and CONFIG_SUSPEND is not set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 kernel/power/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/power/main.c b/kernel/power/main.c
index 0a9f269..7fb805d 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -55,6 +55,8 @@ int pm_notifier_call_chain(unsigned long val)
 
 #endif /* CONFIG_PM_SLEEP */
 
+#ifdef CONFIG_SUSPEND
+
 #ifdef CONFIG_PM_DEBUG
 int pm_test_level = TEST_NONE;
 
-- 
1.5.4.rc5.16.gc0279

