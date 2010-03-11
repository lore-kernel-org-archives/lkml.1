Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934377Ab0CKTA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 14:00:27 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57646 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757939Ab0CKTAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 14:00:25 -0500
Date: Thu, 11 Mar 2010 20:00:17 +0100
From: pavel@ucw.cz
To: linux-geode@lists.infradead.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: lxfb_core: support 800x480 panel
Message-ID: <20100311190017.GA27619@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I need something like this to support full resolution of internal LCD
panel on Kohjinsha subnotebook.

(Note: I basically made up the numbers, if someone knows how to
generate them properly, let me know. It somehow works even on external
display, but last few columns are missing.)

Signed-off-by: Pavel Machek <pavel@ucw.cz>

index 889cbe3..2c04a01 100644
--- a/drivers/video/geode/lxfb_core.c
+++ b/drivers/video/geode/lxfb_core.c
@@ -37,6 +37,9 @@ static int vt_switch;
  */
 
 static struct fb_videomode geode_modedb[] __initdata = {
+	/* 800x480-?? */
+	{ NULL, 60, 800, 480, 25131, 72, 32, 29, 1, 136, 6,
+	  0, FB_VMODE_NONINTERLACED, 0 },
 	/* 640x480-60 */
 	{ NULL, 60, 640, 480, 39682, 48, 8, 25, 2, 88, 2,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
