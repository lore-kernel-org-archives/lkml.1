Return-Path: <linux-kernel-owner+w=401wt.eu-S1751831AbXCEBx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbXCEBx7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbXCEBtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:49:49 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49941 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751982AbXCEBt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:49:28 -0500
Date: Mon, 5 Mar 2007 02:49:30 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       James Simmons <jsimmons@infradead.org>, adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make drivers/video/display/display-sysfs.c:display_class static
Message-ID: <20070305014929.GZ3441@stusta.de>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-mm2:
>...
> +fbdev-display-class.patch
> +fbdev-display-class-update.patch
>...
>  fbdev updates
>...

This patch makes the needlessly global struct display_class static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc2-mm1/drivers/video/display/display-sysfs.c.old	2007-03-04 21:49:31.000000000 +0100
+++ linux-2.6.21-rc2-mm1/drivers/video/display/display-sysfs.c	2007-03-04 21:49:38.000000000 +0100
@@ -127,7 +127,7 @@
 
 static struct mutex allocated_dsp_lock;
 static DEFINE_IDR(allocated_dsp);
-struct class *display_class;
+static struct class *display_class;
 
 struct display_device *display_device_register(struct display_driver *driver,
 						struct device *parent, void *devdata)

