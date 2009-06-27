Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZF0Ili@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZF0Ili (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 04:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZF0Il2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 04:41:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:39226 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbZF0Il1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 04:41:27 -0400
Subject: Re: [PATCH] gitignore: add *.bz2 and *.cpio to top-level; clean up
 usr/
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>, benh@kernel.crashing.org,
       paulus@samba.org
In-Reply-To: <20090627074706.GA30839@uranus.ravnborg.org>
References: <200906202056.n5KKuc9o013960@tazenda.hos.anvin.org>
	 <1245569547.2480.18.camel@ht.satnam>
	 <20090626222112.GB27048@uranus.ravnborg.org> <4A454A69.4050301@zytor.com>
	 <20090626224321.GA27310@uranus.ravnborg.org> <4A4550FD.7020806@zytor.com>
	 <20090627074706.GA30839@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 14:11:01 +0530
Message-Id: <1246092061.2961.12.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-27 at 09:47 +0200, Sam Ravnborg wrote:

> 
> Convinced with respect to the *.gz *.bz2 *.lzma or *.cpio extensions.
> But I will continue to be reluctant to adding global entries,
> as I have been beated from time to time by something
> that was ignored but should not have been so.
> 
> Jaswinder - please resend your patch that
> add these 4 extensions to the top-level .gitignore
> and remove them from .gitignore in the rest of the tree.
> 

[PATCH] gitignore: Add *.gz *.bz2 *.lzma and *.cpio extensions to top-level and remove from rest of the tree

Add *.gz, *.bz2, *.lzma and *.cpio extensions to the top-level .gitignore
and remove them from .gitignore in the rest of the tree

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
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
index 3d80c3e..44fd5b6 100644
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



