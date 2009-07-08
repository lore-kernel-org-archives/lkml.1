Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbZGHOrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbZGHOrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758011AbZGHOrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:47:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:52224 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758131AbZGHOrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:47:09 -0400
Subject: [PATCH 8/44] includecheck fix: arm, mach-mx3/devices.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:08:42 +0530
Message-Id: <1247063922.4382.25.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/arm/mach-mx3/devices.c: linux/dma-mapping.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/arm/mach-mx3/devices.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mx3/devices.c b/arch/arm/mach-mx3/devices.c
index d927edd..9e87e08 100644
--- a/arch/arm/mach-mx3/devices.c
+++ b/arch/arm/mach-mx3/devices.c
@@ -22,7 +22,6 @@
 #include <linux/platform_device.h>
 #include <linux/serial.h>
 #include <linux/gpio.h>
-#include <linux/dma-mapping.h>
 #include <mach/hardware.h>
 #include <mach/irqs.h>
 #include <mach/common.h>
-- 
1.6.0.6



