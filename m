Return-Path: <linux-kernel-owner+w=401wt.eu-S965333AbZLHBXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965333AbZLHBXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 20:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965289AbZLHBXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 20:23:14 -0500
Received: from kroah.org ([198.145.64.141]:55252 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965270AbZLHBXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 20:23:14 -0500
Subject: patch staging-vt6x-depends-on-wlan.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
From: <gregkh@suse.de>
Date: Mon, 07 Dec 2009 17:20:44 -0800
In-Reply-To: <20091206100055.218cfd52.randy.dunlap@oracle.com>
Message-ID: <12602352441028@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: vt6x depends on WLAN

to my gregkh-2.6 tree.  Its filename is

    staging-vt6x-depends-on-wlan.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From randy.dunlap@oracle.com  Mon Dec  7 16:25:39 2009
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Sun, 6 Dec 2009 10:00:55 -0800
Subject: Staging: vt6x depends on WLAN
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Message-ID: <20091206100055.218cfd52.randy.dunlap@oracle.com>


From: Randy Dunlap <randy.dunlap@oracle.com>

The vt665[56] drivers can be built when CONFIG_NET=n &
CONFIG_NETDEVICES=n or just when CONFIG_WLAN=n.
This leads to build failures.
Prevent this by making them depend on WLAN.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/vt6655/Kconfig |    2 +-
 drivers/staging/vt6656/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/vt6655/Kconfig
+++ b/drivers/staging/vt6655/Kconfig
@@ -1,6 +1,6 @@
 config VT6655
    tristate "VIA Technologies VT6655 support"
-   depends on WIRELESS_EXT && PCI
+   depends on WIRELESS_EXT && PCI && WLAN
    ---help---
    This is a vendor-written driver for VIA VT6655.
 
--- a/drivers/staging/vt6656/Kconfig
+++ b/drivers/staging/vt6656/Kconfig
@@ -1,6 +1,6 @@
 config VT6656
 	tristate "VIA Technologies VT6656 support"
-	depends on WIRELESS_EXT && USB
+	depends on WIRELESS_EXT && USB && WLAN
 	---help---
 	This is a vendor-written driver for VIA VT6656.
 

