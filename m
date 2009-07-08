Return-Path: <linux-kernel-owner+w=401wt.eu-S1759809AbZGHOst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809AbZGHOst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759139AbZGHOrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:47:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:52257 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759061AbZGHOrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:47:46 -0400
Subject: [PATCH 12/44] includecheck fix: arm, plat-stmp3xxx/pinmux.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:13:24 +0530
Message-Id: <1247064204.4382.31.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/arm/plat-stmp3xxx/pinmux.c: linux/sysdev.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/arm/plat-stmp3xxx/pinmux.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-stmp3xxx/pinmux.c b/arch/arm/plat-stmp3xxx/pinmux.c
index d412003..6d6b1a4 100644
--- a/arch/arm/plat-stmp3xxx/pinmux.c
+++ b/arch/arm/plat-stmp3xxx/pinmux.c
@@ -22,7 +22,6 @@
 #include <linux/sysdev.h>
 #include <linux/string.h>
 #include <linux/bitops.h>
-#include <linux/sysdev.h>
 #include <linux/irq.h>
 
 #include <mach/hardware.h>
-- 
1.6.0.6



