Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbYFAJ45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbYFAJ45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 05:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYFAJ4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 05:56:48 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:52509 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbYFAJ4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 05:56:47 -0400
Date: Sun, 1 Jun 2008 11:56:40 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k libc5 regression
In-Reply-To: <20080601014824.528173bb.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0806011155080.5559@anakin>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
 <Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
 <20080601005338.3affe880.akpm@linux-foundation.org> <Pine.LNX.4.64.0806011035420.5559@anakin>
 <20080601014824.528173bb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008, Andrew Morton wrote:
> On Sun, 1 Jun 2008 10:37:59 +0200 (CEST) Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > I shall merge this fix into my tree (y'know - the one where memory
> > > management patches are hosted) and I'll get it into 2.6.26 and shall
> > > offer it to the -stable team.  This will cause me to get collisions
> > > with the duplicated patch in linux-next but fortunately it is small. 
> > > This time.
> > 
> > So what's the appropriate way to handle this?
> 
> Well at least please reply letting people know what's happening with it.
> 
> Ask me to merge it and remind me that it's needed in -stable.  Or just
> send the thing to Linus and -stable immediately.  Copy me and I'll do
> the usual merge-it-in-case-linus-misses-it trick.
> 
> > I should have kept it in the m68k series after NEXT_PATCHES_END, so
> > nobody sees it exists?
> 
> That would work, as long as we know that the patch is firmly on the
> mainline and -stable paths.

OK.

As you've been faster than me, I assume you will take care of it now anyway?

Here's an additional one... Can you add this one too?

Thx!

Subject: [PATCH] m68k: enable CONFIG_COMPAT_BRK by default

As some m68k machines have plenty of libc5 binaries in active use, enable
CONFIG_COMPAT_BRK by default.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/configs/amiga_defconfig    |    6 +++---
 arch/m68k/configs/apollo_defconfig   |    6 +++---
 arch/m68k/configs/atari_defconfig    |    6 +++---
 arch/m68k/configs/bvme6000_defconfig |    6 +++---
 arch/m68k/configs/hp300_defconfig    |    6 +++---
 arch/m68k/configs/mac_defconfig      |    6 +++---
 arch/m68k/configs/multi_defconfig    |    6 +++---
 arch/m68k/configs/mvme147_defconfig  |    6 +++---
 arch/m68k/configs/mvme16x_defconfig  |    6 +++---
 arch/m68k/configs/q40_defconfig      |    6 +++---
 arch/m68k/configs/sun3_defconfig     |    6 +++---
 arch/m68k/configs/sun3x_defconfig    |    6 +++---
 12 files changed, 36 insertions(+), 36 deletions(-)

--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:41 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:42 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:43 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:45 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:46 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:47 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:42:31 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:49 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:50 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:51 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:53 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc2
-# Sun May 18 14:44:54 2008
+# Linux kernel version: 2.6.26-rc4
+# Wed May 28 22:47:35 2008
 #
 CONFIG_M68K=y
 CONFIG_MMU=y
@@ -59,7 +59,7 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
-# CONFIG_COMPAT_BRK is not set
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
