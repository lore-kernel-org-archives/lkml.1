Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbYLCT6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbYLCT6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbYLCTuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:35 -0500
Received: from kroah.org ([198.145.64.141]:59617 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752667AbYLCTu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:26 -0500
Date: Wed, 3 Dec 2008 11:49:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Gregor Jasny <gjasny@web.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 019/104] V4L/DVB (9352): Add some missing compat32 ioctls
Message-ID: <20081203194901.GT8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-dvb-add-some-missing-compat32-ioctls.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Gregor Jasny <jasny@vidsoft.de>

commit c7f09db6852d85e7f76322815051aad1c88d08cf upstream.

This patch adds the missing compat ioctls that are needed to
operate Skype in combination with libv4l and a MJPEG only camera.

If you think it's trivial enough please submit it to -stable, too.

Signed-off-by: Gregor Jasny <gjasny@web.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/compat_ioctl32.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/video/compat_ioctl32.c
+++ b/drivers/media/video/compat_ioctl32.c
@@ -867,6 +867,7 @@ long v4l_compat_ioctl32(struct file *fil
 	case VIDIOC_STREAMON32:
 	case VIDIOC_STREAMOFF32:
 	case VIDIOC_G_PARM:
+	case VIDIOC_S_PARM:
 	case VIDIOC_G_STD:
 	case VIDIOC_S_STD:
 	case VIDIOC_G_TUNER:
@@ -885,6 +886,8 @@ long v4l_compat_ioctl32(struct file *fil
 	case VIDIOC_S_INPUT32:
 	case VIDIOC_TRY_FMT32:
 	case VIDIOC_S_HW_FREQ_SEEK:
+	case VIDIOC_ENUM_FRAMESIZES:
+	case VIDIOC_ENUM_FRAMEINTERVALS:
 		ret = do_video_ioctl(file, cmd, arg);
 		break;
 

