Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbXFCUzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbXFCUzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbXFCUyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:54:23 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52704 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753424AbXFCUyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:54:22 -0400
Date: Sun, 3 Jun 2007 22:54:24 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kratochvil <honza@jikos.cz>,
       dmitry.torokhov@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-joystick@atrey.karlin.mff.cuni.cz
Subject: [-mm patch] make xpad_play_effect() static
Message-ID: <20070603205424.GQ5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 11:58:23PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc2-mm1:
>...
>  git-input.patch
>...
>  git trees
>...

This patch makes the needlessly global xpad_play_effect() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc3-mm1/drivers/input/joystick/xpad.c.old	2007-06-03 22:24:23.000000000 +0200
+++ linux-2.6.22-rc3-mm1/drivers/input/joystick/xpad.c	2007-06-03 22:24:39.000000000 +0200
@@ -376,7 +376,8 @@
 		   __FUNCTION__, retval);
 }
 
-int xpad_play_effect(struct input_dev *dev, void *data, struct ff_effect *effect)
+static int xpad_play_effect(struct input_dev *dev, void *data,
+			    struct ff_effect *effect)
 {
 	struct usb_xpad *xpad = input_get_drvdata(dev);
 

