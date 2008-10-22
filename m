Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYJVRmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYJVRmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757850AbYJVReg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:34:36 -0400
Received: from kroah.org ([198.145.64.141]:53087 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757717AbYJVReg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:34:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 26/42] Staging: wlan-ng: fix build error if wireless networking is not enabled
Date: Wed, 22 Oct 2008 10:29:07 -0700
Message-Id: <1224696563-5170-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Ingo for pointing this out.

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/wlan-ng/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlan-ng/Kconfig b/drivers/staging/wlan-ng/Kconfig
index 10b1f0f..2425d86 100644
--- a/drivers/staging/wlan-ng/Kconfig
+++ b/drivers/staging/wlan-ng/Kconfig
@@ -1,6 +1,6 @@
 config PRISM2_USB
 	tristate "Prism2.5 USB driver"
-	depends on USB
+	depends on WLAN_80211 && USB
 	default n
 	---help---
 	  This is the wlan-ng prism 2.5 USB driver for a wide range of
-- 
1.6.0.2

