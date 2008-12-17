Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753052AbYLQTa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbYLQTa7 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYLQT3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:29:18 -0500
Received: from kroah.org ([198.145.64.141]:54242 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751492AbYLQT3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:29:16 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/4] STAGING: Move staging drivers back to staging-specific menu
Date: Wed, 17 Dec 2008 11:28:23 -0800
Message-Id: <1229542103-24678-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20081217192737.GA24641@kroah.com>
References: <20081217192737.GA24641@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Baryshkov <dbaryshkov@gmail.com>

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index c95b286..5d457c9 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -22,6 +22,8 @@ menuconfig STAGING
 	  If in doubt, say N here.
 
 
+if STAGING
+
 config STAGING_EXCLUDE_BUILD
 	bool "Exclude Staging drivers from being built" if STAGING
 	default y
@@ -62,3 +64,4 @@ source "drivers/staging/at76_usb/Kconfig"
 source "drivers/staging/poch/Kconfig"
 
 endif # !STAGING_EXCLUDE_BUILD
+endif # STAGING
-- 
1.6.0.4

