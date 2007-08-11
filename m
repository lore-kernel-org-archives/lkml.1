Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbXHKOlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbXHKOlY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 10:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbXHKOlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 10:41:15 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:52096 "EHLO spock.one.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755678AbXHKOlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 10:41:14 -0400
Date: Sat, 11 Aug 2007 16:40:50 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] uvesafb: add info about pmipal, yrap and ypan being
	available only on x86
Message-ID: <20070811144050.GE13632@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Features that use the Protected Mode Interface are available on x86 only.
Document this in the uvesafb description.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/Documentation/fb/uvesafb.txt b/Documentation/fb/uvesafb.txt
index cfc4e55..1a3b65b 100644
--- a/Documentation/fb/uvesafb.txt
+++ b/Documentation/fb/uvesafb.txt
@@ -59,11 +59,12 @@ Accepted options:
 ypan    Enable display panning using the VESA protected mode
         interface.  The visible screen is just a window of the
         video memory, console scrolling is done by changing the
-        start of the window.
+        start of the window.  Available on x86 only.
 
 ywrap   Same as ypan, but assumes your gfx board can wrap-around
         the video memory (i.e. starts reading from top if it
         reaches the end of video memory).  Faster than ypan.
+        Available on x86 only.
 
 redraw  Scroll by redrawing the affected part of the screen, this
         is the safe (and slow) default.
@@ -75,7 +76,7 @@ vgapal  Use the standard VGA registers for palette changes.
 
 pmipal  Use the protected mode interface for palette changes.
         This is the default if the protected mode interface is
-        available.
+        available.  Available on x86 only.
 
 mtrr:n  Setup memory type range registers for the framebuffer
         where n:


