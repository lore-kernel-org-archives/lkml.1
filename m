Return-Path: <linux-kernel-owner+w=401wt.eu-S1030603AbXBMAhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030603AbXBMAhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030605AbXBMAhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:37:38 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:19979 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030603AbXBMAhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:37:38 -0500
Message-ID: <826775f30702121637q3f843e14t55cb2a1dcf20bb95@mail.gmail.com>
Date: Tue, 13 Feb 2007 02:37:36 +0200
From: "Damian Minkov" <damencho@damencho.com>
To: video4linux-list@redhat.com
Subject: [PATCH] video4linux: Fix audio input for AverTv Go 007
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

from Damian Minkov

Fix audio input source for capturing(playing) audio on AverTv Go 007 cards.

Signed-off-by: Damian Minkov <damencho@damencho.com>
---
diff -upr a/linux/drivers/media/video/saa7134/saa7134-cards.c
b/linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c    2007-02-13
02:17:55.000000000 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c    2007-02-13
02:20:40.000000000 +0200
@@ -1544,12 +1544,12 @@ struct saa7134_board saa7134_boards[] =
         },{
             .name = name_comp1,
             .vmux = 0,
-            .amux = LINE2,
+            .amux = LINE1,
             .gpio = 0x02,
         },{
             .name = name_svideo,
             .vmux = 6,
-            .amux = LINE2,
+            .amux = LINE1,
             .gpio = 0x02,
         }},
         .radio = {
