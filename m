Return-Path: <linux-kernel-owner+w=401wt.eu-S934115AbZLFTE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115AbZLFTE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 14:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934114AbZLFTE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 14:04:27 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:38058 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315AbZLFTE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 14:04:26 -0500
Date: Sun, 6 Dec 2009 10:00:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next resend] staging: vt6x depends on WLAN
Message-Id: <20091206100055.218cfd52.randy.dunlap@oracle.com>
In-Reply-To: <20091204203014.e8ee54ca.sfr@canb.auug.org.au>
References: <20091204203014.e8ee54ca.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B1C002F.0054:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The vt665[56] drivers can be built when CONFIG_NET=n &
CONFIG_NETDEVICES=n or just when CONFIG_WLAN=n.
This leads to build failures.
Prevent this by making them depend on WLAN.

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
