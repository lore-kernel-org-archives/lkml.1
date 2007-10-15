Return-Path: <linux-kernel-owner+w=401wt.eu-S1763652AbXJONq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763652AbXJONq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 09:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757551AbXJONqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 09:46:50 -0400
Received: from hyat.suomi.net ([82.128.152.22]:61086 "EHLO hyat.suomi.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554AbXJONqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 09:46:49 -0400
X-Greylist: delayed 1801 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Oct 2007 09:46:49 EDT
Date: Mon, 15 Oct 2007 16:16:21 +0300
From: =?ISO-8859-1?Q?Pekka_Sepp=E4nen?= <pexu@kapsi.fi>
Subject: [PATCH] radio-gemtek: fix 'VID_HARDWARE_GEMTEK' undeclared
In-reply-to: <20071015111345.GA26777@elte.hu>
To: Linux and Kernel Video <video4linux-list@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Douglas Schilling Landgraf <dougsland@gmail.com>,
       Trent Piepho <xyzzy@speakeasy.org>, Ingo Molnar <mingo@elte.hu>
Message-id: <47136825.9010101@kapsi.fi>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
X-DNA-MailScanner-Information: Please contact the ISP for more information
X-DNA-MailScanner: Found to be clean
X-DNA-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=-0.91,
	required 5, AWL -0.01, BAYES_00 -1.00, RDNS_DYNAMIC 0.10)
X-DNA-MailScanner-From: pexu@kapsi.fi
References: <20071015111345.GA26777@elte.hu>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove obsolete V4L v1 reference.

Signed-off-by: Pekka Seppänen <pexu@kapsi.fi>
---

Ingo Molnar wrote:
> randconfig testing of latest -git found this build bug:
> 
> drivers/media/radio/radio-gemtek.c:557: error: 'VID_HARDWARE_GEMTEK' undeclared here (not in a function)
> 
> config attached.

.hardware = VID_HARDWARE_GEMTEK was from pre-V4L2 era module. My bad, sorry folks.

diff -up v4l-dvb/linux/drivers/media/radio/radio-gemtek.c{.orig,}
--- v4l-dvb/linux/drivers/media/radio/radio-gemtek.c.orig       2007-10-15 15:52:38.000000000 +0300
+++ v4l-dvb/linux/drivers/media/radio/radio-gemtek.c    2007-10-15 15:52:53.000000000 +0300
@@ -555,7 +555,6 @@ static struct video_device gemtek_radio
        .owner                  = THIS_MODULE,
        .name                   = "GemTek Radio card",
        .type                   = VID_TYPE_TUNER,
-       .hardware               = VID_HARDWARE_GEMTEK,
        .fops                   = &gemtek_fops,
        .vidioc_querycap        = vidioc_querycap,
        .vidioc_g_tuner         = vidioc_g_tuner,
