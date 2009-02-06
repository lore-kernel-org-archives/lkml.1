Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbZBFVdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbZBFVdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 16:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbZBFVdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 16:33:45 -0500
Received: from mail.atlantis.sk ([80.94.52.35]:41837 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbZBFVdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 16:33:44 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: airlied@linux.ie
Subject: [PATCH] agpgart: Detected ALi M???? chipset with M1621
Date: Fri, 6 Feb 2009 22:33:32 +0100
User-Agent: KMail/1.9.10
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1023
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200902062233.33509.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
just tried Linux on PC Chips M726 board with ALi Aladdin Pro II chipset (M1621 
+ M1543). It shows:
agpgart: Detected ALi M???? chipset
The patch below fixes that.


Add M1621 chipset name to ali-agp, preventing "Detected ALi M???? chipset" 
message.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.28-orig/drivers/char/agp/ali-agp.c	2009-02-06 22:28:00.000000000 +0100
+++ linux/drivers/char/agp/ali-agp.c	2009-02-06 22:28:11.000000000 +0100
@@ -346,7 +346,7 @@
 			devs[j].chipset_name = "M1641";
 			break;
 		case 0x43:
-			devs[j].chipset_name = "M????";
+			devs[j].chipset_name = "M1621";
 			break;
 		case 0x47:
 			devs[j].chipset_name = "M1647";


-- 
Ondrej Zary
