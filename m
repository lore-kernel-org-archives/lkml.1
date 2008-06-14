Return-Path: <linux-kernel-owner+w=401wt.eu-S1762544AbYFNAQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762544AbYFNAQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758758AbYFNANE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:13:04 -0400
Received: from ns1.suse.de ([195.135.220.2]:34209 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760812AbYFNANB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:13:01 -0400
Date: Fri, 13 Jun 2008 17:10:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Chris Wright <chrisw@sous-sol.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: [patch 12/47] fbdev: export symbol fb_mode_option
Message-ID: <20080614001046.GL24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ps3-fix-frame-buffer-build-error.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Geoff Levand <geoffrey.levand@am.sony.com>

upstream commit: 659179b28f15ab1b1db5f8767090f5e728f115a1

Frame buffer and mode setting drivers can be built as modules,
so fb_mode_option needs to be exported to support these.

Prevents this error:

  ERROR: "fb_mode_option" [drivers/ps3/ps3av_mod.ko] undefined!

Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/video/modedb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/modedb.c
+++ b/drivers/video/modedb.c
@@ -28,6 +28,7 @@
 #endif
 
 const char *fb_mode_option;
+EXPORT_SYMBOL_GPL(fb_mode_option);
 
     /*
      *  Standard video mode definitions (taken from XFree86)

-- 
