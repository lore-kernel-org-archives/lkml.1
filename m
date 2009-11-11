Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbZKKRbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbZKKRbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 12:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758157AbZKKRbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 12:31:49 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:34351 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705AbZKKRbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 12:31:47 -0500
Date: Wed, 11 Nov 2009 09:31:31 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, devel@driverdev.osuosl.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh@suse.de
Subject: [PATCH -next] staging/vt665*: depends on WLAN
Message-Id: <20091111093131.66e7f4ec.randy.dunlap@oracle.com>
In-Reply-To: <20091111203159.a2a6eeeb.sfr@canb.auug.org.au>
References: <20091111203159.a2a6eeeb.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4AFAF4FE.00D8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The vt665[56] drivers can be built when CONFIG_NET=n &
CONFIG_NETDEVICES=n.  This leads to build failures.
Prevent this by making them depend on WLAN.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/vt6655/Kconfig |    2 +-
 drivers/staging/vt6656/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20091110.orig/drivers/staging/vt6655/Kconfig
+++ linux-next-20091110/drivers/staging/vt6655/Kconfig
@@ -1,6 +1,6 @@
 config VT6655
    tristate "VIA Technologies VT6655 support"
-   depends on PCI
+   depends on PCI && WLAN
    select WIRELESS_EXT
    select WEXT_PRIV
    ---help---
--- linux-next-20091110.orig/drivers/staging/vt6656/Kconfig
+++ linux-next-20091110/drivers/staging/vt6656/Kconfig
@@ -1,6 +1,6 @@
 config VT6656
 	tristate "VIA Technologies VT6656 support"
-	depends on USB
+	depends on USB && WLAN
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	---help---
