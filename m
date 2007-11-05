Return-Path: <linux-kernel-owner+w=401wt.eu-S1757120AbXKERGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbXKERGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbXKERGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:06:12 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59456 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754753AbXKERGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:06:10 -0500
Date: Mon, 5 Nov 2007 18:05:46 +0100
From: Adrian Bunk <bunk@kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pekka Pietikainen <pp@ee.oulu.fi>
Subject: [2.6 patch] remove Documentation/networking/ncsa-telnet
Message-ID: <20071105170546.GS12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Newsflash: There once was a version of NCSA telnet that had some bug.

Spotted by Pekka Pietikainen.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/networking/00-INDEX    |    2 --
 Documentation/networking/ncsa-telnet |   16 ----------------
 2 files changed, 18 deletions(-)

b9ccc5424cc83b4c0ca9c8d380a4b7567916a463 
diff --git a/Documentation/networking/00-INDEX b/Documentation/networking/00-INDEX
index a9f4acc..9c64042 100644
--- a/Documentation/networking/00-INDEX
+++ b/Documentation/networking/00-INDEX
@@ -74,8 +74,6 @@ ltpc.txt
 	- the Apple or Farallon LocalTalk PC card driver
 multicast.txt
 	- Behaviour of cards under Multicast
-ncsa-telnet
-	- notes on how NCSA telnet (DOS) breaks with MTU discovery enabled.
 netdevices.txt
 	- info on network device driver functions exported to the kernel.
 olympic.txt
diff --git a/Documentation/networking/ncsa-telnet b/Documentation/networking/ncsa-telnet
deleted file mode 100644
index d77d28b..0000000
--- a/Documentation/networking/ncsa-telnet
+++ /dev/null
@@ -1,16 +0,0 @@
-NCSA telnet doesn't work with path MTU discovery enabled. This is due to a
-bug in NCSA that also stops it working with other modern networking code
-such as Solaris.
-
-The following information is courtesy of 
-Marek <marekm@i17linuxb.ists.pwr.wroc.pl>
-
-There is a fixed version somewhere on ftp.upe.ac.za (sorry, I don't
-remember the exact pathname, and this site is very slow from here).
-It may or may not be faster for you to get it from
-ftp://ftp.ists.pwr.wroc.pl/pub/msdos/telnet/ncsa_upe/tel23074.zip
-(source is in v230704s.zip).  I have tested it with 1.3.79 (with
-path mtu discovery enabled - ncsa 2.3.08 didn't work) and it seems
-to work.  I don't know if anyone is working on this code - this
-version is over a year old.  Too bad - it's faster and often more
-stable than these windoze telnets, and runs on almost anything...

