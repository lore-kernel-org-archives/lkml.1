Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499Ab0AUE1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab0AUE1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171Ab0AUE1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:27:49 -0500
Received: from kroah.org ([198.145.64.141]:60084 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169Ab0AUEW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:22:56 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:34 2010
Message-Id: <20100121041834.559028434@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roel Kluin <roel.kluin@gmail.com>,
       Jean-Francois Moine <moinejf@free.fr>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [16/30] V4L/DVB (13868): gspca - sn9c20x: Fix test of unsigned.
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit c60503c1db76bd46577cc7ff4fafa033b675e0e5 upstream.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/gspca/sn9c20x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/gspca/sn9c20x.c
+++ b/drivers/media/video/gspca/sn9c20x.c
@@ -2319,7 +2319,7 @@ static void do_autogain(struct gspca_dev
 		}
 	}
 	if (avg_lum > MAX_AVG_LUM) {
-		if (sd->gain - 1 >= 0) {
+		if (sd->gain >= 1) {
 			sd->gain--;
 			set_gain(gspca_dev);
 		}


