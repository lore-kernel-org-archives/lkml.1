Return-Path: <linux-kernel-owner+w=401wt.eu-S1751395AbZK0FFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbZK0FFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 00:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbZK0FFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 00:05:44 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:38081 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbZK0FFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 00:05:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=x/cOiCh0g4hjJjQSTv5cHHbnlf7e06jb4euvGv4LCVI9wGP9dlT9ypQryRJohfpu4/
         2bxLKSwEfUF0MIfzcHZ5BfwGjCBpfOYCf+nRFYYl1q+hjX9ttQ2rOGo1/vtBLQK7E/ic
         /uxqJaEmOnTAD3iLym9rH9rYoIbnsKfspai6g=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ian@mnementh.co.uk, lethal@linux-sh.org,
       philipp.zabel@gmail.com, pierre@ossman.eu, akpm@linux-foundation.org,
       Magnus Damm <magnus.damm@gmail.com>
Date: Fri, 27 Nov 2009 14:00:14 +0900
Message-Id: <20091127050014.15251.16299.sendpatchset@rxone.opensource.se>
In-Reply-To: <20091127045956.15251.84958.sendpatchset@rxone.opensource.se>
References: <20091127045956.15251.84958.sendpatchset@rxone.opensource.se>
Subject: [PATCH 02/03] mmc: Remove const from tmio-mmc platform data V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch removes the const from the tmio-mmc
platform data parameter "hclk". Needed by the
SDHI driver.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 V2 drops the SDHI bits to simplify merging.

 include/linux/mfd/tmio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 0001/include/linux/mfd/tmio.h
+++ work/include/linux/mfd/tmio.h	2009-11-26 19:02:59.000000000 +0900
@@ -60,7 +60,7 @@ void tmio_core_set_bus_shift(int bus_shi
  * data for the MMC controller
  */
 struct tmio_mmc_data {
-	const unsigned int		hclk;
+	unsigned int		hclk;
 	void (*set_pwr)(struct platform_device *host, int state);
 	void (*set_no_clk_div)(struct platform_device *host, int state);
 };
