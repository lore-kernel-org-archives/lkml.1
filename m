Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532Ab0A1Mx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0A1Mx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 07:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388Ab0A1Mx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 07:53:56 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:41991 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab0A1Mxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 07:53:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jftKWekBbcjN7cR9kUqD2HevsOGbYfe1Zb79duG1CYNRm+B/ZygmPTVGkDrTzJZJ9J
         9PrMUWbEDZiQvkyeOgJLM1MnJBmaMhFV7fe7sL79askDyX+Rz3AQSeEYAU8ZLOeWffjw
         LhhDbisLzE0ilyERrTSm0x02jmz/5mjnvIUUQ=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux@arm.linux.org.uk
Cc: eric.y.miao@gmail.com, tony@atomide.com, linux-kernel@vger.kernel.org,
       khilman@deeprootsystems.com, lethal@linux-sh.org, ben-linux@fluff.org,
       Magnus Damm <magnus.damm@gmail.com>,
       linux-arm-kernel@lists.infradead.org
Date: Thu, 28 Jan 2010 21:41:12 +0900
Message-Id: <20100128124112.8982.731.sendpatchset@rxone.opensource.se>
In-Reply-To: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se>
References: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se>
Subject: [PATCH 04/06] sh: Build drivers/sh for SuperH Mobile ARM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Build drivers/sh in the case for SuperH Mobile ARM.
Shared code for the interrupt controller (INTC) and
the gpio/pinmux (PFC) is located there.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- 0001/drivers/Makefile
+++ work/drivers/Makefile	2010-01-19 15:39:21.000000000 +0900
@@ -99,6 +99,7 @@ obj-$(CONFIG_SGI_SN)		+= sn/
 obj-y				+= firmware/
 obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
+obj-$(CONFIG_ARCH_SHMOBILE)	+= sh/
 obj-$(CONFIG_GENERIC_TIME)	+= clocksource/
 obj-$(CONFIG_DMA_ENGINE)	+= dma/
 obj-$(CONFIG_DCA)		+= dca/
