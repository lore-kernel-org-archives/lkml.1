Return-Path: <linux-kernel-owner+w=401wt.eu-S1752639AbXA3BMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbXA3BMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 20:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbXA3BMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 20:12:21 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47397 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752638AbXA3BLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 20:11:52 -0500
Date: Tue, 30 Jan 2007 02:12:01 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@osdl.org>, v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC: -mm patch] #if 0 v4l_printk_ioctl_arg()
Message-ID: <20070130011201.GF3754@stusta.de>
References: <20070127234928.64d8e437.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070127234928.64d8e437.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 27, 2007 at 11:49:28PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc4-mm1:
>...
>  git-dvb.patch
>...
>  git trees.
>...

v4l_printk_ioctl_arg() is no longer used.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/media/video/v4l2-common.c |    7 ++++++-
 include/media/v4l2-common.h       |    3 ---
 2 files changed, 6 insertions(+), 4 deletions(-)

--- linux-2.6.20-rc6-mm1/include/media/v4l2-common.h.old	2007-01-29 00:02:58.000000000 +0100
+++ linux-2.6.20-rc6-mm1/include/media/v4l2-common.h	2007-01-29 00:03:10.000000000 +0100
@@ -64,9 +64,6 @@
 /* Prints the ioctl in a human-readable format */
 extern void v4l_printk_ioctl(unsigned int cmd);
 
-/* Prints the ioctl and arg in a human-readable format */
-extern void v4l_printk_ioctl_arg(char *s,unsigned int cmd, void *arg);
-
 /* Use this macro for non-I2C drivers. Pass the driver name as the first arg. */
 #define v4l_print_ioctl(name, cmd)  		 \
 	do {  					 \
--- linux-2.6.20-rc6-mm1/drivers/media/video/v4l2-common.c.old	2007-01-29 00:21:54.000000000 +0100
+++ linux-2.6.20-rc6-mm1/drivers/media/video/v4l2-common.c	2007-01-29 00:45:55.000000000 +0100
@@ -271,11 +271,13 @@
 	[V4L2_BUF_TYPE_SLICED_VBI_OUTPUT]  = "slicec-vbi-out",
 };
 
+#if 0
 static char *v4l2_memory_names[] = {
 	[V4L2_MEMORY_MMAP]    = "mmap",
 	[V4L2_MEMORY_USERPTR] = "userptr",
 	[V4L2_MEMORY_OVERLAY] = "overlay",
 };
+#endif  /*  0  */
 
 #define prt_names(a,arr) (((a)>=0)&&((a)<ARRAY_SIZE(arr)))?arr[a]:"unknown"
 
@@ -419,6 +421,7 @@
 };
 #define V4L2_INT_IOCTLS ARRAY_SIZE(v4l2_int_ioctls)
 
+#if 0
 static void v4l_print_pix_fmt (char *s, struct v4l2_pix_format *fmt)
 {
 	printk ("%s: width=%d, height=%d, format=%d, field=%s, "
@@ -427,6 +430,7 @@
 		prt_names(fmt->field,v4l2_field_names),
 		fmt->bytesperline,fmt->sizeimage,fmt->colorspace);
 };
+#endif  /*  0  */
 
 /* Common ioctl debug function. This function can be used by
    external ioctl messages as well as internal V4L ioctl */
@@ -466,6 +470,7 @@
 	}
 }
 
+#if 0
 /* Common ioctl debug function. This function can be used by
    external ioctl messages as well as internal V4L ioctl and its
    arguments */
@@ -1036,6 +1041,7 @@
 	}
 	}
 }
+#endif  /*  0  */
 
 /* ----------------------------------------------------------------- */
 
@@ -1544,7 +1550,6 @@
 EXPORT_SYMBOL(v4l2_field_names);
 EXPORT_SYMBOL(v4l2_type_names);
 EXPORT_SYMBOL(v4l_printk_ioctl);
-EXPORT_SYMBOL(v4l_printk_ioctl_arg);
 
 EXPORT_SYMBOL(v4l2_ctrl_next);
 EXPORT_SYMBOL(v4l2_ctrl_check);

