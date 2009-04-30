Return-Path: <linux-kernel-owner+w=401wt.eu-S932342AbZEAAUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342AbZEAAUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765418AbZEAADe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:03:34 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61966 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765178AbZEAADa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:03:30 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>, linux-sh@vger.kernel.org
Subject: [PATCH 3/7] sh: use NOSAVE_DATA macro for .data.nosave section.
Date: Thu, 30 Apr 2009 19:57:59 -0400
Message-Id: <1241135883-9766-4-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135883-9766-3-git-send-email-tabbott@mit.edu>
References: <1241135883-9766-1-git-send-email-tabbott@mit.edu>
 <1241135883-9766-2-git-send-email-tabbott@mit.edu>
 <1241135883-9766-3-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
---
 arch/sh/kernel/vmlinux_32.lds.S |    7 +------
 arch/sh/kernel/vmlinux_64.lds.S |    7 +------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/sh/kernel/vmlinux_32.lds.S b/arch/sh/kernel/vmlinux_32.lds.S
index 325af0b..5f5e190 100644
--- a/arch/sh/kernel/vmlinux_32.lds.S
+++ b/arch/sh/kernel/vmlinux_32.lds.S
@@ -70,12 +70,7 @@ SECTIONS
 		*(.data.read_mostly)
 
 		PAGE_ALIGNED_DATA
-
-		__nosave_begin = .;
-		*(.data.nosave)
-		. = ALIGN(PAGE_SIZE);
-		__nosave_end = .;
-
+		NOSAVE_DATA
 		DATA_DATA
 		CONSTRUCTORS
 	}
diff --git a/arch/sh/kernel/vmlinux_64.lds.S b/arch/sh/kernel/vmlinux_64.lds.S
index b222700..9cccb3d 100644
--- a/arch/sh/kernel/vmlinux_64.lds.S
+++ b/arch/sh/kernel/vmlinux_64.lds.S
@@ -79,12 +79,7 @@ SECTIONS
 		*(.data.read_mostly)
 
 		PAGE_ALIGNED_DATA
-
-		__nosave_begin = .;
-		*(.data.nosave)
-		. = ALIGN(PAGE_SIZE);
-		__nosave_end = .;
-
+		NOSAVE_DATA
 		DATA_DATA
 		CONSTRUCTORS
 	}
-- 
1.6.2.1

