Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbZGHQFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbZGHQFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758999AbZGHQEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:04:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:53202 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758987AbZGHQEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:04:52 -0400
Subject: [PATCH 32/44] includecheck fix: drivers/video, vgacon.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Martin Mares <mj@ucw.cz>, mchehab@infradead.org,
       linux-media@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 21:10:24 +0530
Message-Id: <1247067624.4382.88.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/video/console/vgacon.c: linux/slab.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/video/console/vgacon.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 59d7d5e..74e96cf 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -180,7 +180,6 @@ static inline void vga_set_mem_top(struct vc_data *c)
 }
 
 #ifdef CONFIG_VGACON_SOFT_SCROLLBACK
-#include <linux/slab.h>
 /* software scrollback */
 static void *vgacon_scrollback;
 static int vgacon_scrollback_tail;
-- 
1.6.0.6



