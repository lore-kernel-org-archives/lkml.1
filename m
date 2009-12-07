Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbZLGAWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbZLGAWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758585AbZLGAWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:22:47 -0500
Received: from kroah.org ([198.145.64.141]:34633 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758405AbZLGANj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:39 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:55 2009
Message-Id: <20091207000655.489018116@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Krufky <mkrufky@kernellabs.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [083/119] V4L/DVB (13314): saa7134: set ts_force_val for the Hauppauge WinTV HVR-1150
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-13314-saa7134-set-ts_force_val-for-the-hauppauge-wintv-hvr-1150.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Krufky <mkrufky@kernellabs.com>

commit 22370ef5035f206283505409c9a64a595c5c7320 upstream.

The Hauppauge WinTV HVR-1150 retail boards require the FORCE_TS_VALID bit
to be set in order to function properly. This change will work on the early
revisions on the board as well, but the final revision will not function
without this change.

Signed-off-by: Michael Krufky <mkrufky@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/saa7134/saa7134-cards.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -3373,6 +3373,7 @@ struct saa7134_board saa7134_boards[] = 
 		.tuner_config   = 3,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.ts_type	= SAA7134_MPEG_TS_SERIAL,
+		.ts_force_val   = 1,
 		.gpiomask       = 0x0800100, /* GPIO 21 is an INPUT */
 		.inputs         = {{
 			.name = name_tv,


