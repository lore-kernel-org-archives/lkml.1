Return-Path: <linux-kernel-owner+w=401wt.eu-S969055AbXFHLes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969055AbXFHLes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 07:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968629AbXFHLeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 07:34:23 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:51094 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S968587AbXFHLeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 07:34:21 -0400
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Subject: [PATCH 1/2] rtc: make example code jump to done instead of return when ioctl not supported
Date: Fri,  8 Jun 2007 13:34:17 +0200
Message-Id: <11813024582527-git-send-email-hcegtvedt@atmel.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
---
 Documentation/rtc.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/rtc.txt b/Documentation/rtc.txt
index 1ef6bb8..8cc67c7 100644
--- a/Documentation/rtc.txt
+++ b/Documentation/rtc.txt
@@ -388,7 +388,7 @@ test_PIE:
 		/* not all RTCs support periodic IRQs */
 		if (errno == ENOTTY) {
 			fprintf(stderr, "\nNo periodic IRQ support\n");
-			return 0;
+			goto done;
 		}
 		perror("RTC_IRQP_READ ioctl");
 		exit(errno);
-- 
1.4.4.2

