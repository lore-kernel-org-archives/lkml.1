Return-Path: <linux-kernel-owner+w=401wt.eu-S1760617AbZC3Vxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617AbZC3Vxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbZC3Vx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:53:28 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:45469 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbZC3Vx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:53:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=V4WMXic4MH/onTxVepFtx305AsrtB1mueeygoxARlAquVnqbgoUy3s0qQso2RZao39
         UrFM7hsNbKDjwxAhM1ux1KnDSExNAWzWbLcRvGzFuwpsppLYgr9ksdmksOMFkjkwCUZt
         1qKhhhd57pXr+U+vIESMqSbCfDbsPmh3JU2dU=
Date: Mon, 30 Mar 2009 23:53:18 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] uvesafb: documentation update
Message-ID: <20090330215318.GB6540@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the uvesafb documentation to accurately reflect the default
options used by the driver.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/Documentation/fb/uvesafb.txt b/Documentation/fb/uvesafb.txt
index 7ac3c40..a254920 100644
--- a/Documentation/fb/uvesafb.txt
+++ b/Documentation/fb/uvesafb.txt
@@ -59,7 +59,8 @@ Accepted options:
 ypan    Enable display panning using the VESA protected mode
         interface.  The visible screen is just a window of the
         video memory, console scrolling is done by changing the
-        start of the window.  Available on x86 only.
+        start of the window.  This option is available on x86
+        only and is the default option on that architecture.
 
 ywrap   Same as ypan, but assumes your gfx board can wrap-around
         the video memory (i.e. starts reading from top if it
@@ -67,7 +68,7 @@ ywrap   Same as ypan, but assumes your gfx board can wrap-around
         Available on x86 only.
 
 redraw  Scroll by redrawing the affected part of the screen, this
-        is the safe (and slow) default.
+        is the default on non-x86.
 
 (If you're using uvesafb as a module, the above three options are
  used a parameter of the scroll option, e.g. scroll=ypan.)
@@ -182,7 +183,7 @@ from the Video BIOS if you set pixclock to 0 in fb_var_screeninfo.
 
 --
  Michal Januszewski <spock@gentoo.org>
- Last updated: 2007-06-16
+ Last updated: 2009-03-30
 
  Documentation of the uvesafb options is loosely based on vesafb.txt.
 
