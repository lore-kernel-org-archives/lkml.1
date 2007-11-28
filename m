Return-Path: <linux-kernel-owner+w=401wt.eu-S1761965AbXK1WxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761965AbXK1WxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760437AbXK1WxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:53:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:41961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760343AbXK1WxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:53:13 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/6] allow LEGACY_PTYS to be set to 0
Date: Wed, 28 Nov 2007 14:52:15 -0800
Message-Id: <1196290340-28828-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071128224746.GA28410@kroah.com>
References: <20071128224746.GA28410@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

The count of legacy pty devices can be set by a kernel commandline
parameter. For the distro kernel, we would like to disable all pty's
by default, but keep the opportunity to request devices on the kernel
commandline.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index bf18d75..a509b8d 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -457,7 +457,7 @@ config LEGACY_PTYS
 config LEGACY_PTY_COUNT
 	int "Maximum number of legacy PTY in use"
 	depends on LEGACY_PTYS
-	range 1 256
+	range 0 256
 	default "256"
 	---help---
 	  The maximum number of legacy PTYs that can be used at any one time.
-- 
1.5.3.4

