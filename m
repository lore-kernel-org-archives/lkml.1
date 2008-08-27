Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYH0O3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYH0O3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYH0O3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:29:14 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:54382 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbYH0O3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:29:13 -0400
Date: Wed, 27 Aug 2008 23:29:13 +0900 (JST)
Message-Id: <20080827.232913.119238767.anemo@mba.ocn.ne.jp>
To: Henk.Vergonet@gmail.com
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] input: Move map_to_7segment.h to include/linux
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The map_to_7segment.h provides generic 7segment LED mappings and is
designed to be used by other drivers.  Moving it to common area will
make it more usable.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
This is renaming patch.  I can send no-rename patch if requested.

 drivers/input/misc/yealink.c                       |    2 +-
 .../input/misc => include/linux}/map_to_7segment.h |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)
 rename {drivers/input/misc => include/linux}/map_to_7segment.h (99%)

diff --git a/drivers/input/misc/yealink.c b/drivers/input/misc/yealink.c
index facefd3..11b5c7e 100644
--- a/drivers/input/misc/yealink.c
+++ b/drivers/input/misc/yealink.c
@@ -52,8 +52,8 @@
 #include <linux/module.h>
 #include <linux/rwsem.h>
 #include <linux/usb/input.h>
+#include <linux/map_to_7segment.h>
 
-#include "map_to_7segment.h"
 #include "yealink.h"
 
 #define DRIVER_VERSION "yld-20051230"
diff --git a/drivers/input/misc/map_to_7segment.h b/include/linux/map_to_7segment.h
similarity index 99%
rename from drivers/input/misc/map_to_7segment.h
rename to include/linux/map_to_7segment.h
index a424094..db45f7c 100644
--- a/drivers/input/misc/map_to_7segment.h
+++ b/include/linux/map_to_7segment.h
@@ -1,6 +1,4 @@
 /*
- * drivers/usb/input/map_to_7segment.h
- *
  * Copyright (c) 2005 Henk Vergonet <Henk.Vergonet@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
-- 
1.5.6.3

