Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbYAaGrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbYAaGrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 01:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYAaGr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 01:47:29 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:6642 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbYAaGr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 01:47:28 -0500
X-IronPort-AV: E=Sophos;i="4.25,282,1199682000"; 
   d="scan'208";a="61281586"
Subject: [PATCH 11/12 try #2] [Blackfin] serial driver: ADSP-BF52x
	arch/mach support
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Bryan Wu <bryan.wu@analog.com>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
In-Reply-To: <8bd0f97a0801301301k3951fi8dbe52ed859c9165@mail.gmail.com>
References: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
	 <1201685412-29095-12-git-send-email-bryan.wu@analog.com>
	 <8bd0f97a0801301301k3951fi8dbe52ed859c9165@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 31 Jan 2008 14:47:25 +0800
Message-Id: <1201762045.7487.4.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 31 Jan 2008 06:47:26.0634 (UTC) FILETIME=[242F90A0:01C863D5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c7070625a67da75c62bc4ee76417bb89a96b95f6 Mon Sep 17 00:00:00 2001
From: Michael Hennerich <michael.hennerich@analog.com>
Date: Thu, 31 Jan 2008 14:44:40 +0800
Subject: [PATCH] [Blackfin] serial driver: ADSP-BF52x arch/mach support

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index d7e1996..5b70d14 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -667,7 +667,7 @@ config UART0_RTS_PIN
 
 config SERIAL_BFIN_UART1
 	bool "Enable UART1"
-	depends on SERIAL_BFIN && (BF534 || BF536 || BF537 || BF54x)
+	depends on SERIAL_BFIN && (!BF531 && !BF532 && !BF533 && !BF561)
 	help
 	  Enable UART1
 
-- 
1.5.3.4

