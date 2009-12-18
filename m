Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbZLRTgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbZLRTgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbZLRTgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:36:46 -0500
Received: from kroah.org ([198.145.64.141]:47491 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbZLRTgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:36:44 -0500
Subject: patch staging-vt66-kconfig-depends-on-wlan.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
From: <gregkh@suse.de>
Date: Fri, 18 Dec 2009 11:34:00 -0800
In-Reply-To: <20091214084446.8346f39c.randy.dunlap@oracle.com>
Message-ID: <12611648401355@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging/vt66*: kconfig, depends on WLAN

to my gregkh-2.6 tree.  Its filename is

    staging-vt66-kconfig-depends-on-wlan.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From randy.dunlap@oracle.com  Fri Dec 18 10:31:37 2009
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 14 Dec 2009 08:44:46 -0800
Subject: Staging/vt66*: kconfig, depends on WLAN
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Message-ID: <20091214084446.8346f39c.randy.dunlap@oracle.com>


From: Randy Dunlap <randy.dunlap@oracle.com>

The vt665[56] drivers can be built when CONFIG_NET=n &
CONFIG_NETDEVICES=n or just when CONFIG_WLAN=n.
This leads to build failures.
Prevent this by making them depend on WLAN.

[This patch was lost in a dualing trees merge;
still needs to be re-applied.]

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
-   depends on PCI
+   depends on PCI && WLAN
    select WIRELESS_EXT
    select WEXT_PRIV
    ---help---
--- a/drivers/staging/vt6656/Kconfig
+++ b/drivers/staging/vt6656/Kconfig
@@ -1,6 +1,6 @@
 config VT6656
 	tristate "VIA Technologies VT6656 support"
-	depends on USB
+	depends on USB && WLAN
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	---help---

