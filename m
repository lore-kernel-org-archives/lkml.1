Return-Path: <linux-kernel-owner+w=401wt.eu-S965625AbXBTASZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965625AbXBTASZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965591AbXBTASX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:18:23 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36095 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965589AbXBTAHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:07:34 -0500
Date: Tue, 20 Feb 2007 01:07:32 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make pvr2_encoder_prep_config() static
Message-ID: <20070220000732.GW13958@stusta.de>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc6-mm3:
>...
>  git-dvb.patch
>...
>  git trees.
>...

This patch makes the needlessly global pvr2_encoder_prep_config() 
static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm1/drivers/media/video/pvrusb2/pvrusb2-encoder.c.old	2007-02-17 17:52:21.000000000 +0100
+++ linux-2.6.20-mm1/drivers/media/video/pvrusb2/pvrusb2-encoder.c	2007-02-17 17:52:30.000000000 +0100
@@ -324,7 +324,7 @@
 
 /* This implements some extra setup for the encoder that seems to be
    specific to the PVR USB2 hardware. */
-int pvr2_encoder_prep_config(struct pvr2_hdw *hdw)
+static int pvr2_encoder_prep_config(struct pvr2_hdw *hdw)
 {
 	int ret = 0;
 	int encMisc3Arg = 0;
