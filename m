Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbYCMQCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbYCMQCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbYCMQCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:02:10 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:27424 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbYCMQCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:02:09 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>
Subject: [PATCH 04/10] avr32: Rename at32ap.c -> pdc.c
Date: Thu, 13 Mar 2008 15:39:39 +0100
Message-Id: <1205419185-26395-5-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205419185-26395-4-git-send-email-hskinnemoen@atmel.com>
References: <>
 <1205419185-26395-1-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-2-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-3-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-4-git-send-email-hskinnemoen@atmel.com>
X-OriginalArrivalTime: 13 Mar 2008 14:39:46.0399 (UTC) FILETIME=[155A06F0:01C88518]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only thing left in at32ap.c is some PDC stuff. Rename the file to
reflect what it actually does.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/mach-at32ap/Makefile            |    2 +-
 arch/avr32/mach-at32ap/{at32ap.c => pdc.c} |    0 
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename arch/avr32/mach-at32ap/{at32ap.c => pdc.c} (100%)

diff --git a/arch/avr32/mach-at32ap/Makefile b/arch/avr32/mach-at32ap/Makefile
index e890094..cb44182 100644
--- a/arch/avr32/mach-at32ap/Makefile
+++ b/arch/avr32/mach-at32ap/Makefile
@@ -1,3 +1,3 @@
-obj-y				+= at32ap.o clock.o intc.o extint.o pio.o hsmc.o
+obj-y				+= pdc.o clock.o intc.o extint.o pio.o hsmc.o
 obj-$(CONFIG_CPU_AT32AP700X)	+= at32ap700x.o pm-at32ap700x.o
 obj-$(CONFIG_CPU_FREQ_AT32AP)	+= cpufreq.o
diff --git a/arch/avr32/mach-at32ap/at32ap.c b/arch/avr32/mach-at32ap/pdc.c
similarity index 100%
rename from arch/avr32/mach-at32ap/at32ap.c
rename to arch/avr32/mach-at32ap/pdc.c
-- 
1.5.4.3

