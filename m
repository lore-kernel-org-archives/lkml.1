Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbZKKRbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbZKKRbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 12:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758051AbZKKRbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 12:31:47 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:19543 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164AbZKKRbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 12:31:47 -0500
Date: Wed, 11 Nov 2009 09:31:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, devel@driverdev.osuosl.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh@suse.de
Subject: [PATCH -next] staging/rtl8192u: depends on USB
Message-Id: <20091111093123.f137a04c.randy.dunlap@oracle.com>
In-Reply-To: <20091111203159.a2a6eeeb.sfr@canb.auug.org.au>
References: <20091111203159.a2a6eeeb.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AFAF4FF.00BA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

rtl8192u uses usb_* interfaces so it should depend on USB.

ERROR: "usb_kill_urb" [drivers/staging/rtl8192u/r8192u_usb.ko] undefined!
ERROR: "usb_deregister" [drivers/staging/rtl8192u/r8192u_usb.ko] undefined!
ERROR: "usb_control_msg" [drivers/staging/rtl8192u/r8192u_usb.ko] undefined!
ERROR: "usb_submit_urb" [drivers/staging/rtl8192u/r8192u_usb.ko] undefined!
ERROR: "usb_register_driver" [drivers/staging/rtl8192u/r8192u_usb.ko] undefined!
ERROR: "usb_free_urb" [drivers/staging/rtl8192u/r8192u_usb.ko] undefined!
ERROR: "usb_alloc_urb" [drivers/staging/rtl8192u/r8192u_usb.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/rtl8192u/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20091110.orig/drivers/staging/rtl8192u/Kconfig
+++ linux-next-20091110/drivers/staging/rtl8192u/Kconfig
@@ -1,6 +1,6 @@
 config RTL8192U
 	tristate "RealTek RTL8192U Wireless LAN NIC driver"
-	depends on PCI && WLAN
+	depends on PCI && WLAN && USB
 	depends on WIRELESS_EXT
 	default N
 	---help---
