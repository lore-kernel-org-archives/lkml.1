Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216Ab0BYSAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:00:54 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:54238 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000Ab0BYSAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:00:51 -0500
Message-ID: <4B86B977.6040303@oracle.com>
Date: Thu, 25 Feb 2010 09:55:03 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org, Greg KH <gregkh@suse.de>
Subject: [PATCH -next]  staging: fix wlan-ng printk format warning
References: <20100225183523.80361261.sfr@canb.auug.org.au>
In-Reply-To: <20100225183523.80361261.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B86B997.003B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix prism2fw.c printk format warning:

drivers/staging/wlan-ng/prism2fw.c:209: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/wlan-ng/prism2fw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100225.orig/drivers/staging/wlan-ng/prism2fw.c
+++ linux-next-20100225/drivers/staging/wlan-ng/prism2fw.c
@@ -205,7 +205,7 @@ int prism2_fwtry(struct usb_device *udev
 		return 1;
 	}
 
-	printk(KERN_INFO "prism2_usb: %s will be processed, size %d\n",
+	printk(KERN_INFO "prism2_usb: %s will be processed, size %zu\n",
 	       PRISM2_USB_FWFILE, fw_entry->size);
 	prism2_fwapply((const struct ihex_binrec *)fw_entry->data, wlandev);
 
