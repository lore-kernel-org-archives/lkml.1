Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbYJTViT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbYJTViT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbYJTVg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:36:59 -0400
Received: from kroah.org ([198.145.64.141]:37489 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756023AbYJTVg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:36:59 -0400
Subject: patch staging-sxg-depends-on-x86.patch added to gregkh-2.6 tree
To: sfr@canb.auug.org.au, akpm@linux-foundation.org, charrer@alacritech.com,
       gregkh@suse.de, greg@kroah.com, linux-kernel@vger.kernel.org,
       mmiles@alacritech.com
From: <gregkh@suse.de>
Date: Mon, 20 Oct 2008 14:17:22 -0700
In-Reply-To: <20081020230420.aa85f83b.sfr@canb.auug.org.au>
Message-ID: <1224537442195@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: sxg depends on X86
Subject: linux-next: build failure

to my gregkh-2.6 tree.  Its filename is

    staging-sxg-depends-on-x86.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From sfr@canb.auug.org.au  Mon Oct 20 13:45:45 2008
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 20 Oct 2008 22:59:18 +1100
Subject: Staging: sxg depends on X86
Subject: linux-next: build failure
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, Christopher Harrer <charrer@alacritech.com>, Michael Miles <mmiles@alacritech.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linus
Message-ID: <20081020230420.aa85f83b.sfr@canb.auug.org.au>

From: Stephen Rothwell <sfr@canb.auug.org.au>

sxghif.h has code that explicitly will not build fo other architecures.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/sxg/Kconfig |    1 +
 drivers/staging/sxg/README  |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/staging/sxg/Kconfig
+++ b/drivers/staging/sxg/Kconfig
@@ -1,6 +1,7 @@
 config SXG
 	tristate "Alacritech SLIC Technology Non-Accelerated 10Gbe support"
 	depends on PCI && NETDEV_10000
+	depends on X86
 	default n
 	help
 	  This driver supports the Alacritech SLIC Technology Non-Accelerated
--- a/drivers/staging/sxg/README
+++ b/drivers/staging/sxg/README
@@ -7,6 +7,7 @@ TODO:
 	- remove wrappers
 	- checkpatch.pl cleanups
 	- new functionality that the card needs
+	- remove reliance on x86
 
 Please send patches to:
         Greg Kroah-Hartman <gregkh@suse.de>


Patches currently in gregkh-2.6 which might be from sfr@canb.auug.org.au are

bad/battery-class-driver.patch
staging/staging-sxg-depends-on-x86.patch
