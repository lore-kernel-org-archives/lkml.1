Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbZKJREi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbZKJREi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbZKJREh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:04:37 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:32733 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbZKJREg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:04:36 -0500
Date: Tue, 10 Nov 2009 09:04:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
Subject: [PATCH -next] staging/rtl*: fix typos that cause build failures
Message-Id: <20091110090423.ab8cc342.randy.dunlap@oracle.com>
In-Reply-To: <20091109192246.aa0dfd93.sfr@canb.auug.org.au>
References: <20091109192246.aa0dfd93.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AF99D1E.01B8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Correct sizef() typo to be sizeof().
Correct strcpt() typo to be strcpy().

who build-tested these drivers?

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/rtl8187se/r8180_core.c |    2 +-
 drivers/staging/rtl8192e/r8192E_core.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20091109.orig/drivers/staging/rtl8187se/r8180_core.c
+++ linux-next-20091109/drivers/staging/rtl8187se/r8180_core.c
@@ -79,7 +79,7 @@ MODULE_AUTHOR("Andrea Merello <andreamrl
 MODULE_DESCRIPTION("Linux driver for Realtek RTL8180 / RTL8185 WiFi cards");
 
 
-module_param_string(ifname, ifname, sizef(ifname), S_IRUGO|S_IWUSR);
+module_param_string(ifname, ifname, sizeof(ifname), S_IRUGO|S_IWUSR);
 module_param(hwseqnum,int, S_IRUGO|S_IWUSR);
 module_param(hwwep,int, S_IRUGO|S_IWUSR);
 module_param(channels,int, S_IRUGO|S_IWUSR);
--- linux-next-20091109.orig/drivers/staging/rtl8192e/r8192E_core.c
+++ linux-next-20091109/drivers/staging/rtl8192e/r8192E_core.c
@@ -126,7 +126,7 @@ MODULE_DEVICE_TABLE(pci, rtl8192_pci_id_
 MODULE_DESCRIPTION("Linux driver for Realtek RTL819x WiFi cards");
 
 
-module_param_string(ifname, ifname, sizef(ifname), S_IRUGO|S_IWUSR);
+module_param_string(ifname, ifname, sizeof(ifname), S_IRUGO|S_IWUSR);
 //module_param(hwseqnum,int, S_IRUGO|S_IWUSR);
 module_param(hwwep,int, S_IRUGO|S_IWUSR);
 module_param(channels,int, S_IRUGO|S_IWUSR);
@@ -5972,7 +5972,7 @@ static int __devinit rtl8192_pci_probe(s
 
 	if (dev_alloc_name(dev, ifname) < 0){
                 RT_TRACE(COMP_INIT, "Oops: devname already taken! Trying wlan%%d...\n");
-		strcpt(ifname, "wlan%d");
+		strcpy(ifname, "wlan%d");
 		dev_alloc_name(dev, ifname);
         }
 
