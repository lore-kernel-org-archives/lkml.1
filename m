Return-Path: <linux-kernel-owner+w=401wt.eu-S1763155AbYCAQ3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763155AbYCAQ3Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763034AbYCAQYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:24:43 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57412 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758026AbYCAQYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:24:42 -0500
Date: Sat, 1 Mar 2008 18:23:16 +0200
From: Adrian Bunk <bunk@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make cdrom.c:check_for_audio_disc() static
Message-ID: <20080301162316.GA25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global check_for_audio_disc() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
3b370f4edc826997a406f09c21a612e812e882fd foobar
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index db259e6..12f5bae 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -1152,8 +1152,8 @@ clean_up_and_return:
 /* This code is similar to that in open_for_data. The routine is called
    whenever an audio play operation is requested.
 */
-int check_for_audio_disc(struct cdrom_device_info * cdi,
-			 struct cdrom_device_ops * cdo)
+static int check_for_audio_disc(struct cdrom_device_info * cdi,
+				struct cdrom_device_ops * cdo)
 {
         int ret;
 	tracktype tracks;

