Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab0BPW7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 17:59:40 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:42714 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab0BPW7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 17:59:38 -0500
Message-ID: <4B7B233B.9030601@oracle.com>
Date: Tue, 16 Feb 2010 14:59:07 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH -next] staging/rtl8187se: needs semaphore.h
References: <20100216185534.fdc8eed3.sfr@canb.auug.org.au>
In-Reply-To: <20100216185534.fdc8eed3.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B7B234F.0194:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

rtl8187se needs to include semaphore.h to prevent build errors:

drivers/staging/rtl8187se/ieee80211/ieee80211.h:1004: error: field 'wx_sem' has incomplete type
drivers/staging/rtl8187se/ieee80211/ieee80211.h:1005: error: field 'scan_sem' has incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100216.orig/drivers/staging/rtl8187se/ieee80211/ieee80211.h
+++ linux-next-20100216/drivers/staging/rtl8187se/ieee80211/ieee80211.h
@@ -29,6 +29,7 @@
 #include <linux/jiffies.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
+#include <linux/semaphore.h>
 #include <linux/wireless.h>
 #include <linux/ieee80211.h>
 
