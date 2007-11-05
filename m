Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744AbXKEHdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbXKEHdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 02:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbXKEHdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 02:33:33 -0500
Received: from ro-out-1112.google.com ([72.14.202.176]:23861 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbXKEHdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 02:33:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=bKjI5lcS6T86KzYYouh2GHAERzyG+F9l3mIIk7MAtiFWgkb4HUaWCk3Rhx8GpszsrGsZOR6nWjaa3fSh9/T7MIINh5x7E/TKAOcHgJmznCdFhXYy3X7LUNZEUc/sceXGNsSpcSPoyiBXEHK0u2p5Wn+/gqifrdsUKZuAm2Zvejc=
Date: Mon, 5 Nov 2007 15:32:33 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: [git Patch] Makefile: Remove ncscope.out when make mrproper
Message-ID: <20071105073233.GC2461@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Sam!

This patch adds the ncscope.out file into cleaning targets of 'make mrproper'.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>

---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/Makefile
===================================================================
--- linux-2.6.orig/Makefile
+++ linux-2.6/Makefile
@@ -1073,7 +1073,7 @@ MRPROPER_DIRS  += include/config include
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
-		  Module.symvers tags TAGS cscope*
+		  Module.symvers tags TAGS cscope* ncscope.out
 
 # clean - Delete most, but leave enough to build external modules
 #
