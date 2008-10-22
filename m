Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbYJVRiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbYJVRiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbYJVRdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:33:20 -0400
Received: from kroah.org ([198.145.64.141]:53042 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757419AbYJVRdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:33:14 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Huang Weiyi <weiyi.huang@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/42] Staging: SLICOSS: remove unused #include <version.h>
Date: Wed, 22 Oct 2008 10:28:55 -0700
Message-Id: <1224696563-5170-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Weiyi <weiyi.huang@gmail.com>

The file(s) below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
  drivers/staging/slicoss/slicoss.c

This patch removes the said #include <version.h>.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/slicoss/slicoss.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 69f3ea2..6ef9274 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -54,7 +54,6 @@
  *       IS-NIC driver.
  */
 
-#include <linux/version.h>
 
 #define SLIC_DUMP_ENABLED               0
 #define KLUDGE_FOR_4GB_BOUNDARY         1
-- 
1.6.0.2

