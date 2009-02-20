Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbZBTPri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbZBTPri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZBTPqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:46:55 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35429 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753892AbZBTPqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:46:53 -0500
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, Kyle McMartin <kyle@mcmartin.ca>,
       David Woodhouse <dwmw2@infradead.org>,
       Richard Zidlicky <rz@linux-m68k.org>, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 1/5] rtc-parisc: Add missing module alias
Date: Fri, 20 Feb 2009 16:46:45 +0100
Message-Id: <1235144809-32468-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1235144809-32468-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1235144809-32468-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make udev autoload the driver

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/rtc/rtc-parisc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-parisc.c b/drivers/rtc/rtc-parisc.c
index c6bfa6f..28fb7d3 100644
--- a/drivers/rtc/rtc-parisc.c
+++ b/drivers/rtc/rtc-parisc.c
@@ -110,3 +110,4 @@ module_exit(parisc_rtc_fini);
 MODULE_AUTHOR("Kyle McMartin <kyle@mcmartin.ca>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("HP PA-RISC RTC driver");
+MODULE_ALIAS("platform:rtc-parisc");
-- 
1.6.0.4

