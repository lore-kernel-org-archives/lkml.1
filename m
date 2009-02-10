Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbZBJU5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbZBJU5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZBJU5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:57:30 -0500
Received: from mail.atlantis.sk ([80.94.52.35]:42456 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbZBJU5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:57:30 -0500
To: airlied@linux.ie
Subject: [PATCH] [resend] agpgart: Detected ALi M???? chipset with M1621
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, davej@redhat.com
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Tue, 10 Feb 2009 21:57:13 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200902102157.15575.linux@rainbow-software.org>
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

