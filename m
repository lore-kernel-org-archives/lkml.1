Return-Path: <linux-kernel-owner+w=401wt.eu-S1751726AbZIXKjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbZIXKjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 06:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbZIXKjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 06:39:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:38355 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbZIXKjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 06:39:09 -0400
Subject: [PATCH] blackfin: includecheck fix: mach-bf548, ezkit.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Mike Frysinger <vapier@gentoo.org>,
       Michael Hennerich <michael.hennerich@analog.com>,
       uclinux-dist-devel@blackfin.uclinux.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 16:08:09 +0530
Message-Id: <1253788689.5860.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/blackfin/mach-bf548/boards/ezkit.c: linux/input.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Michael Hennerich <michael.hennerich@analog.com>
---
 arch/blackfin/mach-bf548/boards/ezkit.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index c66f380..383a18c 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -208,7 +208,6 @@ static struct platform_device bfin_rotary_device = {
 #endif
 
 #if defined(CONFIG_INPUT_ADXL34X) || defined(CONFIG_INPUT_ADXL34X_MODULE)
-#include <linux/input.h>
 #include <linux/spi/adxl34x.h>
 static const struct adxl34x_platform_data adxl34x_info = {
 	.x_axis_offset = 0,
-- 
1.6.0.6


