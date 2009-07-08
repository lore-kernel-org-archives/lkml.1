Return-Path: <linux-kernel-owner+w=401wt.eu-S1759359AbZGHQGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359AbZGHQGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517AbZGHQEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:04:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:53204 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758903AbZGHQEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:04:52 -0400
Subject: [PATCH 31/44] includecheck fix: drivers/staging, rt_linux.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 21:07:00 +0530
Message-Id: <1247067420.4382.85.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/staging/rt2860/rt_linux.h: linux/wireless.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/staging/rt2860/rt_linux.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_linux.h
index 85175c1..ed75673 100644
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -66,10 +66,6 @@
 #include <linux/ctype.h>
 #include <linux/vmalloc.h>
 
-
-#ifdef RT30xx
-#include <linux/wireless.h>
-#endif
 #include <net/iw_handler.h>
 
 // load firmware
-- 
1.6.0.6



