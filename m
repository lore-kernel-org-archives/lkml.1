Return-Path: <linux-kernel-owner+w=401wt.eu-S1751488AbZLOFhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbZLOFhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 00:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbZLOFhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 00:37:51 -0500
Received: from mail.gmx.net ([213.165.64.20]:48215 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751248AbZLOFhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 00:37:50 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+onVVKe5GoebQ3W8JB2s00bo2SdmoWtnNMYkStUi
	PBZyfQ70dtV+DX
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: devel@driverdev.osuosl.org, Willy Tarreau <w@1wt.eu>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
       Costantino Leandro <lcostantino@gmail.com>,
       linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] drivers/staging/panel: Adjust range for PANEL_KEYPAD in Kconfig
Date: Tue, 15 Dec 2009 06:37:36 +0100
Message-Id: <1260855456-25012-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.6.4.4
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In panel.c there are only the values 0-3 defined. So 4 is invalid:

Patch against current linux-next tree at Tue Dec 15 06:31:01 2009 +0100

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/panel/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/panel/Kconfig b/drivers/staging/panel/Kconfig
index 3abe7c9..3defa01 100644
--- a/drivers/staging/panel/Kconfig
+++ b/drivers/staging/panel/Kconfig
@@ -47,7 +47,7 @@ config PANEL_PROFILE
 config PANEL_KEYPAD
 	depends on PANEL && PANEL_PROFILE="0"
 	int "Keypad type (0=none, 1=old 6 keys, 2=new 6 keys, 3=Nexcom 4 keys)"
-	range 0 4
+	range 0 3
 	default 0
 	---help---
 	  This enables and configures a keypad connected to the parallel port.
-- 
1.6.4.4

