Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbZLGAYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbZLGAYE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbZLGANc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:32 -0500
Received: from kroah.org ([198.145.64.141]:34515 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758531AbZLGANY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:24 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:52 2009
Message-Id: <20091207000652.162070217@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean-Francois Moine <moinejf@free.fr>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Michael Krufky <mkrufky@linuxtv.org>
Subject: [067/119] V4L/DVB (12691): gspca - sonixj: Dont use mdelay().
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-12691-gspca-sonixj-don-t-use-mdelay.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean-Francois Moine <moinejf@free.fr>

commit 1f78a976ce18bc98e8b509cee04c5b3756098614 upstream.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/gspca/sonixj.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -1150,7 +1150,7 @@ static int configure_gpio(struct gspca_d
 		reg_w1(gspca_dev, 0x17, 0x20);
 		reg_w1(gspca_dev, 0x01, 0x62);
 		reg_w1(gspca_dev, 0x01, 0x42);
-		mdelay(100);
+		msleep(100);
 		reg_w1(gspca_dev, 0x02, 0x62);
 		break;
 /*	case SENSOR_HV7131R: */


