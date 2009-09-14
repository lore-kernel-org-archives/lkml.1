Return-Path: <linux-kernel-owner+w=401wt.eu-S933882AbZINUYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882AbZINUYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756935AbZINUIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:15 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:53974 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756898AbZINUIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:14 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 01/72] Blackfin: bf537-stamp: update ADP5588 header name
Date: Mon, 14 Sep 2009 16:07:05 -0400
Message-Id: <1252958896-25150-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf537/boards/stamp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index bd65690..b8e8c92 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -1089,7 +1089,7 @@ static struct platform_device i2c_bfin_twi_device = {
 
 #if defined(CONFIG_KEYBOARD_ADP5588) || defined(CONFIG_KEYBOARD_ADP5588_MODULE)
 #include <linux/input.h>
-#include <linux/i2c/adp5588_keys.h>
+#include <linux/i2c/adp5588.h>
 static const unsigned short adp5588_keymap[ADP5588_KEYMAPSIZE] = {
 	[0]	 = KEY_GRAVE,
 	[1]	 = KEY_1,
-- 
1.6.4.2

