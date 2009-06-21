Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbZFUHcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbZFUHcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 03:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZFUHcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 03:32:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:41960 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbZFUHcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 03:32:04 -0400
Subject: Re: [PATCH] gitignore: add *.bz2 and *.cpio to top-level; clean up
 usr/
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>, benh@kernel.crashing.org,
       paulus@samba.org
In-Reply-To: <200906202056.n5KKuc9o013960@tazenda.hos.anvin.org>
References: <200906202056.n5KKuc9o013960@tazenda.hos.anvin.org>
Content-Type: text/plain
Date: Sun, 21 Jun 2009 13:02:27 +0530
Message-Id: <1245569547.2480.18.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2009-06-20 at 13:52 -0700, H. Peter Anvin wrote:
> Add *.bz2 and *.cpio to the top-level gitignore file, for consistency
> with *.gz and *.lzma which are already there.  Remove specific rules
> in usr/gitignore, since they are now covered by the global rules.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>

It seems this is based on my patch :

[PATCH] gitignore usr/initramfs_data.cpio.bz2 and usr/initramfs_data.cpio.lzma

And you forget to CC me ;-)

Are you trying to do this, fill signed-off-by and enjoy :

[PATCH] Add *.bz2 and *.cpio to the top-level gitignore file, for consistency
 with *.gz and *.lzma which are already there.  Remove specific rules
 in other gitignores, since they are now covered by the global rules.

---
 .gitignore                          |    2 ++
 Documentation/DocBook/.gitignore    |    1 -
 arch/arm/boot/compressed/.gitignore |    1 -
 arch/powerpc/boot/.gitignore        |    1 -
 kernel/.gitignore                   |    1 -
 usr/.gitignore                      |    2 --
 6 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/.gitignore b/.gitignore
index cecb3b0..a255340 100644
--- a/.gitignore
+++ b/.gitignore
@@ -25,6 +25,8 @@
 *.elf
 *.bin
 *.gz
+*.bz2
+*.cpio
 *.lzma
 *.patch
 
diff --git a/Documentation/DocBook/.gitignore b/Documentation/DocBook/.gitignore
index c6def35..0c91638 100644
--- a/Documentation/DocBook/.gitignore
+++ b/Documentation/DocBook/.gitignore
@@ -2,7 +2,6 @@
 *.ps
 *.pdf
 *.html
-*.9.gz
 *.9
 *.aux
 *.dvi
diff --git a/arch/arm/boot/compressed/.gitignore b/arch/arm/boot/compressed/.gitignore
index ab204db..269b788 100644
--- a/arch/arm/boot/compressed/.gitignore
+++ b/arch/arm/boot/compressed/.gitignore
@@ -1,3 +1,2 @@
 font.c
-piggy.gz
 vmlinux.lds
diff --git a/arch/powerpc/boot/.gitignore b/arch/powerpc/boot/.gitignore
index 2f50acd..af4105b 100644
--- a/arch/powerpc/boot/.gitignore
+++ b/arch/powerpc/boot/.gitignore
@@ -16,7 +16,6 @@ inftrees.h
 infutil.c
 infutil.h
 kernel-vmlinux.strip.c
-kernel-vmlinux.strip.gz
 mktree
 uImage
 cuImage.*
diff --git a/kernel/.gitignore b/kernel/.gitignore
index ab4f109..04f6d83 100644
--- a/kernel/.gitignore
+++ b/kernel/.gitignore
@@ -2,5 +2,4 @@
 # Generated files
 #
 config_data.h
-config_data.gz
 timeconst.h
diff --git a/usr/.gitignore b/usr/.gitignore
index 69b2e89..4d7d9f4 100644
--- a/usr/.gitignore
+++ b/usr/.gitignore
@@ -2,7 +2,5 @@
 # Generated files
 #
 gen_init_cpio
-initramfs_data.cpio
-initramfs_data.cpio.gz
 initramfs_list
 include
-- 
1.6.0.6



