Return-Path: <linux-kernel-owner+w=401wt.eu-S933035AbZKDV5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035AbZKDV5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933007AbZKDV5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:57:54 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:45607 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004AbZKDV5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:57:53 -0500
Date: Wed, 4 Nov 2009 13:56:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: RTL8192SU depends on USB
Message-Id: <20091104135623.8542c041.randy.dunlap@oracle.com>
In-Reply-To: <20091102173845.210d1c57.sfr@canb.auug.org.au>
References: <20091102173845.210d1c57.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AF1F8DB.0169:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

USB device driver needs to depend on USB to prevent build errors:

ERROR: "usb_kill_urb" [drivers/staging/rtl8192su/r8192s_usb.ko] undefined!
ERROR: "usb_deregister" [drivers/staging/rtl8192su/r8192s_usb.ko] undefined!
ERROR: "usb_control_msg" [drivers/staging/rtl8192su/r8192s_usb.ko] undefined!
ERROR: "usb_submit_urb" [drivers/staging/rtl8192su/r8192s_usb.ko] undefined!
ERROR: "usb_register_driver" [drivers/staging/rtl8192su/r8192s_usb.ko] undefined!
ERROR: "usb_free_urb" [drivers/staging/rtl8192su/r8192s_usb.ko] undefined!
ERROR: "usb_alloc_urb" [drivers/staging/rtl8192su/r8192s_usb.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/rtl8192su/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20091102.orig/drivers/staging/rtl8192su/Kconfig
+++ linux-next-20091102/drivers/staging/rtl8192su/Kconfig
@@ -1,6 +1,6 @@
 config RTL8192SU
 	tristate "RealTek RTL8192SU Wireless LAN NIC driver"
-	depends on PCI && WLAN
+	depends on PCI && WLAN && USB
 	depends on WIRELESS_EXT
 	default N
 	---help---
