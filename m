Return-Path: <linux-kernel-owner+w=401wt.eu-S932268AbYDUNYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbYDUNYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757636AbYDUNTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:10 -0400
Received: from el-out-1112.google.com ([209.85.162.183]:25531 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760001AbYDUNTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=A+f8LwqM8ZkjiHOG0VquCpJ7vNzHZEJ/tESQ+W+H04EPrWT8xbquzI0vYQPJ5il6uHlFEicmnRrP/2lzKGpzw9rw+9O86g6stBFAH7id6Ke9ydpav9qmX0/hiza97XNhhubqowHN+JndCi19fm5HVFEFu3HxMDWPss2dMXnTcHI=
Message-Id: <1b8930dc64b6842e50711441ba67482aacc475dd.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Mon, 10 Mar 2008 13:43:05 +0100
Subject: [PATCH 29/37] Input: fix ordering in joystick Makefile
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Jiri Kosina <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make entries in drivers/input/joystick/Makefile properly alphabetically
ordered.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/joystick/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/input/joystick/Makefile b/drivers/input/joystick/Makefile
index 868b746..e262840 100644
--- a/drivers/input/joystick/Makefile
+++ b/drivers/input/joystick/Makefile
@@ -15,9 +15,11 @@ obj-$(CONFIG_JOYSTICK_GF2K)		+= gf2k.o
 obj-$(CONFIG_JOYSTICK_GRIP)		+= grip.o
 obj-$(CONFIG_JOYSTICK_GRIP_MP)		+= grip_mp.o
 obj-$(CONFIG_JOYSTICK_GUILLEMOT)	+= guillemot.o
+obj-$(CONFIG_JOYSTICK_IFORCE)		+= iforce/
 obj-$(CONFIG_JOYSTICK_INTERACT)		+= interact.o
 obj-$(CONFIG_JOYSTICK_JOYDUMP)		+= joydump.o
 obj-$(CONFIG_JOYSTICK_MAGELLAN)		+= magellan.o
+obj-$(CONFIG_JOYSTICK_MAPLE)		+= maplecontrol.o
 obj-$(CONFIG_JOYSTICK_SIDEWINDER)	+= sidewinder.o
 obj-$(CONFIG_JOYSTICK_SPACEBALL)	+= spaceball.o
 obj-$(CONFIG_JOYSTICK_SPACEORB)		+= spaceorb.o
@@ -29,4 +31,3 @@ obj-$(CONFIG_JOYSTICK_WARRIOR)		+= warrior.o
 obj-$(CONFIG_JOYSTICK_XPAD)		+= xpad.o
 obj-$(CONFIG_JOYSTICK_ZHENHUA)		+= zhenhua.o
 
-obj-$(CONFIG_JOYSTICK_IFORCE)		+= iforce/
-- 
1.5.5.rc2.6.gf58d


