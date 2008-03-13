Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbYCMQGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbYCMQGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYCMQG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:06:29 -0400
Received: from anchor-post-32.mail.demon.net ([194.217.242.90]:2093 "EHLO
	anchor-post-32.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982AbYCMQG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:06:28 -0400
X-Greylist: delayed 826 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Mar 2008 12:06:28 EDT
Date: Thu, 13 Mar 2008 15:35:49 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-kernel@vger.kernel.org
Cc: ambx1@neo.rr.com, stable@kernel.org
Message-ID: <4F84E87BA4%linux@youmustbejoking.demon.co.uk>
Mail-Followup-To: linux-kernel@vger.kernel.org, ambx1@neo.rr.com, 
 stable@kernel.org, Darren Salt <linux@youmustbejoking.demon.co.uk>
User-Agent: Gemini/2.29e (Qt/3.3.8b) (Linux-x86_64)
X-SDate: Thu, 5308 Sep 1993 15:35:49 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
Subject: [PATCH 2.6.24] Increase the number of PnP memory resources from 12 to 24
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on pentagram.youmustbejoking.demon.co.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase the number of PnP memory resources from 12 to 24.

This removes an "exceeded the max num of mem resources" warning on boot. I
also noticed the reservation of two more iomem ranges on the computer on
which this was tested.

Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>

diff -u ./include/linux/pnp.h~ ./include/linux/pnp.h
--- ./include/linux/pnp.h~	2008-03-13 14:41:19.000000000 +0000
+++ ./include/linux/pnp.h	2008-03-13 14:41:19.000000000 +0000
@@ -14,7 +14,7 @@
 #include <linux/mod_devicetable.h>
 
 #define PNP_MAX_PORT		40
-#define PNP_MAX_MEM		12
+#define PNP_MAX_MEM		24
 #define PNP_MAX_IRQ		2
 #define PNP_MAX_DMA		2
 #define PNP_NAME_LEN		50

-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Output less CO2 => avoid massive flooding.    TIME IS RUNNING OUT *FAST*.

Seafood diet: see food, eat it.
