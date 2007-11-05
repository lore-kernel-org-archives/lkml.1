Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbXKERIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbXKERIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbXKERGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:06:46 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59474 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756810AbXKERGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:06:45 -0500
Date: Mon, 5 Nov 2007 18:06:22 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove Documentation/smp.txt
Message-ID: <20071105170622.GY12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After seeing the filename I'd have expected something about the 
implementation of SMP in the Linux kernel - not some notes on kernel 
configuration and building trivialities noone would search at this 
place.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/00-INDEX |    2 --
 Documentation/smp.txt  |   22 ----------------------
 2 files changed, 24 deletions(-)

07dd2298fa79d2dd42d3f774bd18e1c074881a4b 
diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 9e94065..9d9a6ae 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -360,8 +360,6 @@ sharedsubtree.txt
 	- a description of shared subtrees for namespaces.
 smart-config.txt
 	- description of the Smart Config makefile feature.
-smp.txt
-	- a few notes on symmetric multi-processing.
 sony-laptop.txt
 	- Sony Notebook Control Driver (SNC) Readme.
 sonypi.txt
diff --git a/Documentation/smp.txt b/Documentation/smp.txt
deleted file mode 100644
index 82fc50b..0000000
--- a/Documentation/smp.txt
+++ /dev/null
@@ -1,22 +0,0 @@
-To set up SMP
-
-Configure the kernel and answer Y to CONFIG_SMP.
-
-If you are using LILO, it is handy to have both SMP and non-SMP
-kernel images on hand. Edit /etc/lilo.conf to create an entry
-for another kernel image called "linux-smp" or something.
-
-The next time you compile the kernel, when running a SMP kernel,
-edit linux/Makefile and change "MAKE=make" to "MAKE=make -jN"
-(where N = number of CPU + 1, or if you have tons of memory/swap
- you can just use "-j" without a number). Feel free to experiment
-with this one.
-
-Of course you should time how long each build takes :-)
-Example:
-   make config
-   time -v sh -c 'make clean install modules modules_install'
-
-If you are using some Compaq MP compliant machines you will need to set
-the operating system in the BIOS settings to "Unixware" - don't ask me
-why Compaqs don't work otherwise.

