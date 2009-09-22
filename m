Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbZIVPKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbZIVPKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbZIVPKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:10:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:40709 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756658AbZIVPKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:10:24 -0400
Subject: [PATCH] STAGING: includecheck fix: vt6656, main_usb.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Forest Bond <forest@alittletooquiet.net>,
       Staging <devel@driverdev.osuosl.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 20:40:22 +0530
Message-Id: <1253632222.3784.43.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warnings:

  drivers/staging/vt6656/main_usb.c: iocmd.h is included more than once.
  drivers/staging/vt6656/main_usb.c: mac.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/staging/vt6656/main_usb.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 7f96bca..9dbb194 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -64,11 +64,9 @@
 #include "ioctl.h"
 #include "iwctl.h"
 #include "dpc.h"
-#include "iocmd.h"
 #include "datarate.h"
 #include "rf.h"
 #include "firmware.h"
-#include "mac.h"
 #include "rndis.h"
 #include "control.h"
 #include "channel.h"
-- 
1.6.0.6


