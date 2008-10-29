Return-Path: <linux-kernel-owner+w=401wt.eu-S1758339AbYJ2W52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339AbYJ2W52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756511AbYJ2WqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:46:25 -0400
Received: from kroah.org ([198.145.64.141]:56272 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755136AbYJ2WqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:46:09 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: "vijaykumar@bravegnu.org" <vijaykumar@bravegnu.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 38/49] Staging: poch: Update TODO list
Date: Wed, 29 Oct 2008 15:40:05 -0700
Message-Id: <1225320016-21803-38-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: vijaykumar@bravegnu.org <vijaykumar@bravegnu.org>

Update TODO list.

Signed-off-by: Vijay Kumar <vijaykumar@bravegnu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/poch/README |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/poch/README b/drivers/staging/poch/README
index f65e979..842afd4 100644
--- a/drivers/staging/poch/README
+++ b/drivers/staging/poch/README
@@ -1,5 +1,12 @@
 TODO:
-	- fix transmit overflows
+	- Rx block size is limited to < 2048, hardware bug?
+	- Group size is limited to < page size, kernel alloc/mmap API issues
+	- fix/workaround cache issues in circular buffer header
+	- test whether Tx is transmitting data from provided buffers
+	- handle device unplug case
+	- handle temperature above threshold
+	- use bus address instead of physical address for DMA
+	- support for snapshot mode
 	- audit userspace interfaces
 	- get reserved major/minor if needed
 
-- 
1.6.0.2

