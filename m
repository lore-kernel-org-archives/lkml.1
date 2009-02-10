Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbZBJR0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbZBJR0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 12:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZBJRZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 12:25:58 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:48749 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbZBJRZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:25:57 -0500
Date: Tue, 10 Feb 2009 09:24:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, gregkh@suse.de, linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187se: depends on WIRELESS_EXT
Message-Id: <20090210092449.1075249d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4991B879.00C9:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

rtl8187se uses wireless extensions so it needs to depend on
WIRELESS_EXT (or select it).

drivers/staging/rtl8187se/r8180_core.c:5973: error: 'struct net_device' has no member named 'wireless_handlers'
drivers/staging/rtl8187se/r8180_core.c:5982: error: 'struct net_device' has no member named 'wireless_handlers'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Greg KH <gregkh@suse.de>
---
 drivers/staging/rtl8187se/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090210.orig/drivers/staging/rtl8187se/Kconfig
+++ linux-next-20090210/drivers/staging/rtl8187se/Kconfig
@@ -1,5 +1,6 @@
 config RTL8187SE
 	tristate "RealTek RTL8187SE Wireless LAN NIC driver"
 	depends on PCI
+	depends on WIRELESS_EXT
 	default N
 	---help---
