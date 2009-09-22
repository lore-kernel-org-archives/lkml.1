Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbZIVPJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbZIVPJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbZIVPJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:09:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:40679 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683AbZIVPJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:09:30 -0400
Subject: [PATCH] STAGING: includecheck fix: vt6656, hostap.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Forest Bond <forest@alittletooquiet.net>,
       Staging <devel@driverdev.osuosl.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 20:39:26 +0530
Message-Id: <1253632166.3784.42.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/staging/vt6656/hostap.c: mac.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/staging/vt6656/hostap.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index 0c8267a..1078d61 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -37,7 +37,6 @@
 #include "baseband.h"
 #include "wpactl.h"
 #include "key.h"
-#include "mac.h"
 #include "datarate.h"
 
 #define VIAWGET_HOSTAPD_MAX_BUF_SIZE 1024
-- 
1.6.0.6


