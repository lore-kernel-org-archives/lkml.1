Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbZK3NoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbZK3NoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 08:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbZK3NoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 08:44:15 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50852 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753221AbZK3NoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 08:44:13 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] staging: fix a silly typo
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 30 Nov 2009 13:24:49 +0000
Message-ID: <20091130132432.27394.48685.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resend #3)

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/rtl8187se/r8180_core.c  |    2 +-
 drivers/staging/rtl8192su/r8192U_core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 5a6cd60..d74bf70 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -79,7 +79,7 @@ MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
 MODULE_DESCRIPTION("Linux driver for Realtek RTL8180 / RTL8185 WiFi cards");
 
 
-module_param_string(ifname, ifname, sizef(ifname), S_IRUGO|S_IWUSR);
+module_param_string(ifname, ifname, sizeof(ifname), S_IRUGO|S_IWUSR);
 module_param(hwseqnum,int, S_IRUGO|S_IWUSR);
 module_param(hwwep,int, S_IRUGO|S_IWUSR);
 module_param(channels,int, S_IRUGO|S_IWUSR);
diff --git a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
index e24815f..0a052ea 100644
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -142,7 +142,7 @@ static int channels = 0x3fff;
 
 
 
-module_param_string(ifname, ifname, sizef(ifname), S_IRUGO|S_IWUSR);
+module_param_string(ifname, ifname, sizeof(ifname), S_IRUGO|S_IWUSR);
 //module_param(hwseqnum,int, S_IRUGO|S_IWUSR);
 module_param(hwwep,int, S_IRUGO|S_IWUSR);
 module_param(channels,int, S_IRUGO|S_IWUSR);

