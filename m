Return-Path: <linux-kernel-owner+w=401wt.eu-S932126AbZJHGFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbZJHGFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932097AbZJHGFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:05:49 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34626 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083AbZJHGFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:05:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Subject: [PATCH 10/13] Blackfin: includecheck fix: mach-bf548, ezkit.c
Date: Thu,  8 Oct 2009 02:04:26 -0400
Message-Id: <1254981869-21586-11-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
References: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Fix the following 'make includecheck' warning:

  arch/blackfin/mach-bf548/boards/ezkit.c: linux/input.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf548/boards/ezkit.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index ba745c6..8798831 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -186,7 +186,6 @@ static struct platform_device bfin_rotary_device = {
 #endif
 
 #if defined(CONFIG_INPUT_ADXL34X) || defined(CONFIG_INPUT_ADXL34X_MODULE)
-#include <linux/input.h>
 #include <linux/spi/adxl34x.h>
 static const struct adxl34x_platform_data adxl34x_info = {
 	.x_axis_offset = 0,
-- 
1.6.5.rc2

