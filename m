Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbYJIXzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbYJIXzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 19:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYJIXy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 19:54:58 -0400
Received: from xenotime.net ([66.160.160.81]:54985 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750891AbYJIXy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 19:54:57 -0400
Date: Thu, 09 Oct 2008 16:52:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/8 for 2.6.27] docs: fix uvesafb mode_option
Message-ID: <12235963551043@xenotime.net>
In-Reply-To: 
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Reported-by: root <thunder7@xs4all.nl>
uvesafb was switched from the 'mode' parameter to the more common (in
fb-land) 'mode_option' parameter, so update the documentation for that.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Krzysztof Helt <krzysztof.h1@wp.pl>
cc: Michal Januszewski <spock@gentoo.org>
---
 Documentation/fb/uvesafb.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.27-rc9-git2.orig/Documentation/fb/uvesafb.txt
+++ linux-2.6.27-rc9-git2/Documentation/fb/uvesafb.txt
@@ -52,7 +52,7 @@ are either given on the kernel command l
 
  video=uvesafb:1024x768-32,mtrr:3,ywrap (compiled into the kernel)
 
- # modprobe uvesafb mode=1024x768-32 mtrr=3 scroll=ywrap  (module)
+ # modprobe uvesafb mode_option=1024x768-32 mtrr=3 scroll=ywrap  (module)
 
 Accepted options:
 
@@ -105,7 +105,7 @@ vtotal:n
 <mode>  The mode you want to set, in the standard modedb format.  Refer to
         modedb.txt for a detailed description.  When uvesafb is compiled as
         a module, the mode string should be provided as a value of the
-        'mode' option.
+        'mode_option' parameter.
 
 vbemode:x
         Force the use of VBE mode x.  The mode will only be set if it's
@@ -182,7 +182,7 @@ from the Video BIOS if you set pixclock 
 
 --
  Michal Januszewski <spock@gentoo.org>
- Last updated: 2007-06-16
+ Last updated: 2008-10-09
 
  Documentation of the uvesafb options is loosely based on vesafb.txt.
 


-- 

