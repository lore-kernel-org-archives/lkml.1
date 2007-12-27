Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbXL0Lb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbXL0Lb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 06:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbXL0Lbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 06:31:50 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:46100 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbXL0Lbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 06:31:49 -0500
Date: Thu, 27 Dec 2007 14:32:04 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] gameport: unexport static inline functions (alpha build
	fix)
Message-ID: <20071227113204.GA22678@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two are defined inline in linux/gameport.h.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 drivers/input/gameport/gameport.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index bfc6061..1dc2ac9 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -38,8 +38,6 @@ EXPORT_SYMBOL(gameport_unregister_driver);
 EXPORT_SYMBOL(gameport_open);
 EXPORT_SYMBOL(gameport_close);
 EXPORT_SYMBOL(gameport_rescan);
-EXPORT_SYMBOL(gameport_cooked_read);
-EXPORT_SYMBOL(gameport_set_name);
 EXPORT_SYMBOL(gameport_set_phys);
 EXPORT_SYMBOL(gameport_start_polling);
 EXPORT_SYMBOL(gameport_stop_polling);
