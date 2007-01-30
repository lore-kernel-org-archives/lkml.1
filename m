Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbXA3BMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbXA3BMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 20:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbXA3BLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 20:11:49 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47383 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752638AbXA3BLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 20:11:45 -0500
Date: Tue, 30 Jan 2007 02:11:53 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@osdl.org>, v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] cx88-video.c: remove struct radionorms
Message-ID: <20070130011153.GC3754@stusta.de>
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

This patch removes the unused struct radionorms.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.20-rc6-mm1/drivers/media/video/cx88/cx88-video.c.old	2007-01-28 23:59:19.000000000 +0100
+++ linux-2.6.20-rc6-mm1/drivers/media/video/cx88/cx88-video.c	2007-01-28 23:59:28.000000000 +0100
@@ -86,8 +86,6 @@
 /* ------------------------------------------------------------------- */
 /* static data                                                         */
 
-v4l2_std_id radionorms[] = { 0 };
-
 static struct cx8800_fmt formats[] = {
 	{
 		.name     = "8 bpp, gray",


