Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbZGHQEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbZGHQEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758456AbZGHQD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:03:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:53160 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758623AbZGHQD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:03:57 -0400
Subject: [PATCH 26/44] includecheck fix: drivers/parisc, ccio-dma.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: kyle@mcmartin.ca, deller@gmx.de, linux-parisc@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:57:20 +0530
Message-Id: <1247066840.4382.74.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/parisc/ccio-dma.c: linux/proc_fs.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/parisc/ccio-dma.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 0f0e0b9..a45b0c0 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -70,7 +70,6 @@
 #undef CCIO_COLLECT_STATS
 #endif
 
-#include <linux/proc_fs.h>
 #include <asm/runway.h>		/* for proc_runway_root */
 
 #ifdef DEBUG_CCIO_INIT
-- 
1.6.0.6



