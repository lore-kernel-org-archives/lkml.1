Return-Path: <linux-kernel-owner+w=401wt.eu-S1765908AbXJTL6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765908AbXJTL6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 07:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758044AbXJTL56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 07:57:58 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:49161 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379AbXJTL55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 07:57:57 -0400
From: Nick Warne <nick@ukfsn.org>
Reply-To: nick@ukfsn.org
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Kconfig bug
Date: Sat, 20 Oct 2007 12:57:55 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_D1eGHgukByqaSlN"
Message-Id: <200710201257.55616.nick@ukfsn.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_D1eGHgukByqaSlN
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,

I noticed I had a module option being built that wasn't in menuconfig.

It is missing description.  I also added a brief help message.

Signed off by:  Nick Warne <nick@ukfsn.org>

Nick
-- 
Free Software Foundation Associate Member 5508

--Boundary-00=_D1eGHgukByqaSlN
Content-Type: text/x-diff;
  charset="us-ascii";
  name="scsi_wait.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="scsi_wait.patch"

--- linux-current/drivers/scsi/Kconfig_old	2007-10-20 12:44:50.000000000 +0100
+++ linux-current/drivers/scsi/Kconfig	2007-10-20 12:57:13.000000000 +0100
@@ -248,10 +248,17 @@
 	  or async on the kernel's command line.
 
 config SCSI_WAIT_SCAN
-	tristate
+	tristate "Wait for SCSI scan completion"
 	default m
 	depends on SCSI
 	depends on MODULES
+	help
+	  The SCSI subsystem can probe for devices while the rest of the
+	  system continues booting, and even probe devices on different
+	  busses in parallel, leading to a significant speed-up.
+
+	  You can load the scsi_wait_scan module to ensure that all scans
+	  have completed.
 
 menu "SCSI Transports"
 	depends on SCSI

--Boundary-00=_D1eGHgukByqaSlN--
