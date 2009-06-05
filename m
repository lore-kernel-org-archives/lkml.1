Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbZFESJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbZFESJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZFESIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:08:52 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:46005 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZFESIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:08:51 -0400
Message-ID: <4A295FF3.6060706@oracle.com>
Date: Fri, 05 Jun 2009 11:12:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
CC: Greg KH <gregkh@suse.de>
Subject: staging/vt6655: uses pci functions, should depend on PCI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.4A295F2E.0205:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

This driver uses lots of pci_*() calls, so it should depend on PCI.

drivers/staging/vt6655/device_main.c:3942: error: implicit declaration of function 'pci_dev_driver'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/vt6655/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090605.orig/drivers/staging/vt6655/Kconfig
+++ linux-next-20090605/drivers/staging/vt6655/Kconfig
@@ -1,5 +1,6 @@
 config VT6655
    tristate "VIA Technologies VT6655 support"
+   depends on PCI
    ---help---
    This is a vendor-written driver for VIA VT6655.
 



-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
