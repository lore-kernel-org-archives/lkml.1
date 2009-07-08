Return-Path: <linux-kernel-owner+w=401wt.eu-S1759586AbZGHQGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbZGHQGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757679AbZGHQFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:05:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:53232 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759101AbZGHQFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:05:13 -0400
Subject: [PATCH 29/44] includecheck fix: drivers/spi, amba-pl022.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 21:02:27 +0530
Message-Id: <1247067147.4382.80.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warnings:

  drivers/spi/amba-pl022.c: linux/delay.h is included more than once.
  drivers/spi/amba-pl022.c: linux/errno.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/spi/amba-pl022.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/amba-pl022.c b/drivers/spi/amba-pl022.c
index da76797..c0f950a 100644
--- a/drivers/spi/amba-pl022.c
+++ b/drivers/spi/amba-pl022.c
@@ -38,14 +38,12 @@
 #include <linux/interrupt.h>
 #include <linux/spi/spi.h>
 #include <linux/workqueue.h>
-#include <linux/errno.h>
 #include <linux/delay.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/pl022.h>
 #include <linux/io.h>
-#include <linux/delay.h>
 
 /*
  * This macro is used to define some register default values.
-- 
1.6.0.6



