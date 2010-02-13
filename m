Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab0BMUC6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 15:02:58 -0500
Received: from lnx503.hrz.tu-darmstadt.de ([130.83.156.232]:42956 "EHLO
	lnx503.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757897Ab0BMUC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 15:02:56 -0500
From: ST <st@iss.tu-darmstadt.de>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: PATCH was Re: 2.6.33-rc7 problems
Date: Sat, 13 Feb 2010 21:02:22 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-00117-ge28cab4; KDE/4.3.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201002092306.07449.st@iss.tu-darmstadt.de> <201002130018.42576.st@iss.tu-darmstadt.de> <51f3faa71002121714y5a5127c2r7f59165c8096f0ee@mail.gmail.com>
In-Reply-To: <51f3faa71002121714y5a5127c2r7f59165c8096f0ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002132102.22177.st@iss.tu-darmstadt.de>
X-PMX-TU: seen v0.99a by 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.2.13.194827
X-PMX-SPAMCHECK: outgoing mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert and lkml
> Do you have CONFIG_SCSI_MULTI_LUN=y set in your kernel configuration?
Ah, hit the nail right on the head. Thank you very much! So if you happen to 
be close to Darmstadt: I owe you a drink just drop me a mail.

To spare others this torment not to be able to configure their on kernel (well 
at least partially) please change the defconfig to have CONFIG_SCSI_MULTI_LUN
enabled. Given the low price of these usb multi card readers this is quite a 
common use case?

Best regards
ST

Signed-off-by:  ST  <st@iss.tu-darmstadt.de>

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index d28fad1..053e8bf 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -847,7 +847,7 @@ CONFIG_CHR_DEV_SG=y
 #
 # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
 #
-# CONFIG_SCSI_MULTI_LUN is not set
+CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_CONSTANTS=y
 # CONFIG_SCSI_LOGGING is not set
 # CONFIG_SCSI_SCAN_ASYNC is not set
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 6c86acd..3f64c27 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -842,7 +842,7 @@ CONFIG_CHR_DEV_SG=y
 #
 # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
 #
-# CONFIG_SCSI_MULTI_LUN is not set
+CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_CONSTANTS=y
 # CONFIG_SCSI_LOGGING is not set
 # CONFIG_SCSI_SCAN_ASYNC is not set
