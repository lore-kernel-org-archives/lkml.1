Return-Path: <linux-kernel-owner+w=401wt.eu-S932156AbZLNQoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbZLNQoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756711AbZLNQox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:44:53 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:29620 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613AbZLNQow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:44:52 -0500
Date: Mon, 14 Dec 2009 08:44:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging/vt66*: kconfig, depends on WLAN
Message-Id: <20091214084446.8346f39c.randy.dunlap@oracle.com>
In-Reply-To: <20091214165927.c08c4784.sfr@canb.auug.org.au>
References: <20091214165927.c08c4784.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B266B7A.018E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The vt665[56] drivers can be built when CONFIG_NET=n &
CONFIG_NETDEVICES=n or just when CONFIG_WLAN=n.
This leads to build failures.
Prevent this by making them depend on WLAN.

[This patch was lost in a dualing trees merge;
still needs to be re-applied.]

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/vt6655/Kconfig |    2 +-
 drivers/staging/vt6656/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20091204.orig/drivers/staging/vt6655/Kconfig
+++ linux-next-20091204/drivers/staging/vt6655/Kconfig
@@ -1,6 +1,6 @@
 config VT6655
    tristate "VIA Technologies VT6655 support"
-   depends on PCI
+   depends on PCI && WLAN
    select WIRELESS_EXT
    select WEXT_PRIV
    ---help---
--- linux-next-20091204.orig/drivers/staging/vt6656/Kconfig
+++ linux-next-20091204/drivers/staging/vt6656/Kconfig
@@ -1,6 +1,6 @@
 config VT6656
 	tristate "VIA Technologies VT6656 support"
-	depends on USB
+	depends on USB && WLAN
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	---help---
