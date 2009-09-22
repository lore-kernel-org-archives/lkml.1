Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbZIVO5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbZIVO5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZIVO5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:57:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:49609 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbZIVO5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:57:01 -0400
Subject: [PATCH] STAGING: includecheck fix: iio, ring_sw.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Greg KH <greg@kroah.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Jonathan Cameron <jic23@cam.ac.uk>, devel@driverdev.osuosl.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 20:26:55 +0530
Message-Id: <1253631415.3784.32.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/staging/iio/ring_sw.c: linux/device.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/staging/iio/ring_sw.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/ring_sw.c b/drivers/staging/iio/ring_sw.c
index 359ff92..b746cf6 100644
--- a/drivers/staging/iio/ring_sw.c
+++ b/drivers/staging/iio/ring_sw.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/device.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/workqueue.h>
-- 
1.6.0.6


