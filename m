Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbYGZNoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbYGZNoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYGZNmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:42:49 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:59438 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbYGZNms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:42:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=B1pdL+HpLvClX09ulkn38lwVYq8Pd6WsKx5J6nmO0IE7c58xjwjKfzuPgJjSCIBvUx
         yId9p7tMoXYBMBB/3uhR3mRtJyPvDExentCBpnAmGVZX3kMq+Yd0gZD9q84hYPojAyYz
         Df5BYyTFDbLOiznyvnCRwP69k/5BgIJY+r4No=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 26 Jul 2008 15:40:44 +0200
Message-Id: <20080726134044.10589.63581.sendpatchset@localhost.localdomain>
In-Reply-To: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
References: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/10] ide: remove unused _IDE_C and _IDE_DISK defines
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |    3 ---
 drivers/ide/ide.c      |    2 --
 2 files changed, 5 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -30,9 +30,6 @@
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/leds.h>
-
-#define _IDE_DISK
-
 #include <linux/ide.h>
 
 #include <asm/byteorder.h>
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -44,8 +44,6 @@
  *  inspiration from lots of linux users, esp.  hamish@zot.apana.org.au
  */
 
-#define _IDE_C			/* Tell ide.h it's really us */
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
