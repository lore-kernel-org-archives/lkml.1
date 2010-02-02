Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab0BBTXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:23:05 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:56453 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab0BBTW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:22:59 -0500
Message-ID: <4B687B15.40608@oracle.com>
Date: Tue, 02 Feb 2010 11:20:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, Lennart Poettering <mzxreary@0pointer.de>
Subject: [PATCH -mmotm] msi-laptop: depends on RFKILL
References: <201002020050.o120ov8X022741@imap1.linux-foundation.org>
In-Reply-To: <201002020050.o120ov8X022741@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B687B86.01D4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

msi-laptop uses rfkill*() interfaces so it should depend on RFKILL.

msi-laptop.c:(.text+0x1fcd1b): undefined reference to `rfkill_alloc'
msi-laptop.c:(.text+0x1fcd76): undefined reference to `rfkill_register'
msi-laptop.c:(.text+0x1fcdc8): undefined reference to `rfkill_destroy'
msi-laptop.c:(.text+0x1fcdd9): undefined reference to `rfkill_unregister'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>
---
  drivers/platform/x86/Kconfig |    1 +
  1 file changed, 1 insertion(+)

--- mmotm-2010-0201-1625.orig/drivers/platform/x86/Kconfig
+++ mmotm-2010-0201-1625/drivers/platform/x86/Kconfig
@@ -147,6 +147,7 @@ config MSI_LAPTOP
  	tristate "MSI Laptop Extras"
  	depends on ACPI
  	depends on BACKLIGHT_CLASS_DEVICE
+	depends on RFKILL
  	---help---
  	  This is a driver for laptops built by MSI (MICRO-STAR
  	  INTERNATIONAL):
