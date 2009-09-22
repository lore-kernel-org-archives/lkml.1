Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbZIVPHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbZIVPHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbZIVPHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:07:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:57288 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbZIVPHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:07:08 -0400
Subject: [PATCH] STAGING: includecheck fix: vt6655, wcmd.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Forest Bond <forest@alittletooquiet.net>,
       Staging <devel@driverdev.osuosl.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 20:37:04 +0530
Message-Id: <1253632024.3784.40.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/staging/vt6655/wcmd.c: card.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/staging/vt6655/wcmd.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index d81f5b7..c9eabf9 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -48,7 +48,6 @@
 #include "wmgr.h"
 #include "power.h"
 #include "wctl.h"
-#include "card.h"
 #include "baseband.h"
 #include "rxtx.h"
 #include "rf.h"
-- 
1.6.0.6


