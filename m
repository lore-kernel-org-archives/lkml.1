Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbZIVPI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbZIVPI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbZIVPI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:08:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:57319 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256AbZIVPI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:08:28 -0400
Subject: [PATCH] STAGING: includecheck fix: vt6656, baseband.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Forest Bond <forest@alittletooquiet.net>,
       Staging <devel@driverdev.osuosl.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 20:38:26 +0530
Message-Id: <1253632106.3784.41.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/staging/vt6656/baseband.c: control.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/staging/vt6656/baseband.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 820a7b8..59a86e2 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -46,7 +46,6 @@
 #include "control.h"
 #include "datarate.h"
 #include "rndis.h"
-#include "control.h"
 
 /*---------------------  Static Definitions -------------------------*/
 static int          msglevel                =MSG_LEVEL_INFO;
-- 
1.6.0.6


