Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYLIV4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYLIV4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 16:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbYLIV4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 16:56:33 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:60403 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbYLIV4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 16:56:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OHyLUssVN/qaNOQBuLw9OGXNGSzis19gdoWZbCAyr7D6rxu3XzrhhFOeQZa5n9Xans
         rG/8vYSQ5ECa+dRTkNVg9EoVP/c9y4s+E6dJ5KlH0k0RlmyOLdLQm5ti6FEOJDHVC8Nl
         niolZhKUDQ1Y3JCf5O3VlZOlQfCHFOjLx/00U=
Message-ID: <493EE98F.8060401@gmail.com>
Date: Tue, 09 Dec 2008 22:56:31 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: video4linux-list@redhat.com, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 24/31] drivers/video: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/video/mb862xx/mb862xxfb.c |    2 +-
 drivers/video/via/hw.c            |    2 +-
 drivers/video/via/viafbdev.c      |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/video/mb862xx/mb862xxfb.c b/drivers/video/mb862xx/mb862xxfb.c
index 38718d9..d9041af 100644
--- a/drivers/video/mb862xx/mb862xxfb.c
+++ b/drivers/video/mb862xx/mb862xxfb.c
@@ -458,7 +458,7 @@ static ssize_t mb862xxfb_show_dispregs(struct device *dev,
 
 static DEVICE_ATTR(dispregs, 0444, mb862xxfb_show_dispregs, NULL);
 
-irqreturn_t mb862xx_intr(int irq, void *dev_id)
+static irqreturn_t mb862xx_intr(int irq, void *dev_id)
 {
 	struct mb862xxfb_par *par = (struct mb862xxfb_par *) dev_id;
 	unsigned long reg_ist, mask;
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index fcd53ce..30493ac 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -553,7 +553,7 @@ void viafb_write_reg_mask(u8 index, int io_port, u8 data, u8 mask)
 	/*DEBUG_MSG(KERN_INFO "\nIndex=%2d Value=%2d", index, tmp); */
 }
 
-void write_dac_reg(u8 index, u8 r, u8 g, u8 b)
+static void write_dac_reg(u8 index, u8 r, u8 g, u8 b)
 {
 	outb(index, LUT_INDEX_WRITE);
 	outb(r, LUT_DATA);
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 73ac754..29d9ed1 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -35,14 +35,14 @@ static char *viafb_mode1 = "640x480";
 static int viafb_resMode = VIA_RES_640X480;
 
 /* Added for specifying active devices.*/
-char *viafb_active_dev = "";
+static char *viafb_active_dev = "";
 
 /* Added for specifying video on devices.*/
-char *viafb_video_dev = "";
+static char *viafb_video_dev = "";
 
 /*Added for specify lcd output port*/
-char *viafb_lcd_port = "";
-char *viafb_dvi_port = "";
+static char *viafb_lcd_port = "";
+static char *viafb_dvi_port = "";
 
 static void viafb_set_device(struct device_t active_dev);
 static int apply_device_setting(struct viafb_ioctl_setting setting_info,

