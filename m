Return-Path: <linux-kernel-owner+w=401wt.eu-S1030877AbXD3LVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030877AbXD3LVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbXD3LVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:21:31 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:48493 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbXD3LVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:21:30 -0400
Date: Mon, 30 Apr 2007 13:20:39 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/36] Use menuconfig objects I.b - block
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301319190.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


block/Kconfig already has its own "menuconfig" so remove these
"menu, endmenu" that did not get cleaned up in the block patch
[ http://lkml.org/lkml/2007/4/10/251 ]

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 init/Kconfig |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.21-mm_20070428.orig/init/Kconfig
+++ linux-2.6.21-mm_20070428/init/Kconfig
@@ -741,6 +741,4 @@ config STOP_MACHINE
 	  Need stop_machine() primitive.
 endmenu
 
-menu "Block layer"
 source "block/Kconfig"
-endmenu
