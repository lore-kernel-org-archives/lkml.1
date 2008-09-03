Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbYICNjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbYICNjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbYICNi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:38:58 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:6695 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbYICNi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:38:57 -0400
X-IronPort-AV: E=Sophos;i="4.32,320,1217822400"; 
   d="scan'208";a="18324186"
From: Alex Nixon <alex.nixon@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alex Nixon <alex.nixon@citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 2/3] Xen: Fix cpu_hotplug build when !CONFIG_SMP
Date: Wed,  3 Sep 2008 14:30:22 +0100
Message-Id: <1220448623-14860-2-git-send-email-alex.nixon@citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1220448623-14860-1-git-send-email-alex.nixon@citrix.com>
References: <>
 <1220448623-14860-1-git-send-email-alex.nixon@citrix.com>
X-OriginalArrivalTime: 03 Sep 2008 13:29:24.0900 (UTC) FILETIME=[1504E640:01C90DC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile cpu_hotplug.c conditionally on CONFIG_HOTPLUG_CPU

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 drivers/xen/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index f62d8df..d2a8fdf 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,4 +1,5 @@
-obj-y	+= grant-table.o features.o events.o manage.o cpu_hotplug.o
+obj-y	+= grant-table.o features.o events.o manage.o
 obj-y	+= xenbus/
+obj-$(CONFIG_HOTPLUG_CPU)	+= cpu_hotplug.o
 obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
 obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
-- 
1.5.4.3

