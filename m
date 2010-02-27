Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967978Ab0B0I1G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 03:27:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:45899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967957Ab0B0I1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 03:27:03 -0500
Subject: [PATCH] drbd: includecheck fix for
 drivers/block/drbd/drbd_receiver.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Philipp Reisner <philipp.reisner@linbit.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>, drbd-user@lists.linbit.com,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Feb 2010 13:55:10 +0530
Message-Id: <1267259110.26906.5.camel@i7.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the following 'make includecheck' warning:
  drivers/block/drbd/drbd_receiver.c: linux/mm.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index d065c64..b6c9855 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -42,7 +42,6 @@
 #include <linux/unistd.h>
 #include <linux/vmalloc.h>
 #include <linux/random.h>
-#include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/scatterlist.h>
 #include "drbd_int.h"
-- 
1.6.6


