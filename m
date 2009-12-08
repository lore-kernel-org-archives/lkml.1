Return-Path: <linux-kernel-owner+w=401wt.eu-S936990AbZLHXOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936990AbZLHXOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 18:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756410AbZLHXOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 18:14:23 -0500
Received: from kroah.org ([198.145.64.141]:55407 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382AbZLHXOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 18:14:22 -0500
Date: Tue, 8 Dec 2009 15:14:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.41
Message-ID: <20091208231418.GB14205@kroah.com>
References: <20091208231406.GA14205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208231406.GA14205@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 4e55a63..12952ec 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .40
+EXTRAVERSION = .41
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
index 95f77b6..ac3292d 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -365,11 +365,6 @@ static int snd_em28xx_hw_capture_free(struct snd_pcm_substream *substream)
 
 static int snd_em28xx_prepare(struct snd_pcm_substream *substream)
 {
-	struct em28xx *dev = snd_pcm_substream_chip(substream);
-
-	dev->adev.hwptr_done_capture = 0;
-	dev->adev.capture_transfer_done = 0;
-
 	return 0;
 }
 
