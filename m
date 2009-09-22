Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbZIVO7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbZIVO7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756543AbZIVO7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:59:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:34344 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbZIVO7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:59:33 -0400
Subject: [PATCH] STAGING: includecheck fix: rt3090, rt_linux.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 20:29:32 +0530
Message-Id: <1253631572.3784.34.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/staging/rt3090/rt_linux.h: linux/wireless.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/staging/rt3090/rt_linux.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rt3090/rt_linux.h b/drivers/staging/rt3090/rt_linux.h
index a970e78..9910879 100644
--- a/drivers/staging/rt3090/rt_linux.h
+++ b/drivers/staging/rt3090/rt_linux.h
@@ -58,7 +58,6 @@
 #include <linux/if_arp.h>
 #include <linux/ctype.h>
 #include <linux/vmalloc.h>
-#include <linux/wireless.h>
 #include <net/iw_handler.h>
 
 #ifdef INF_AMAZON_PPA
-- 
1.6.0.6


