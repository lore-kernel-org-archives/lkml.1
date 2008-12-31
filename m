Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbYLaEWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbYLaEWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 23:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYLaEWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 23:22:43 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:43220 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbYLaEWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 23:22:43 -0500
Message-ID: <495AF348.9080105@oracle.com>
Date: Tue, 30 Dec 2008 20:21:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH] spi.h uses/needs device.h
References: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
In-Reply-To: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.495AF34B.002A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Include header files as used/needed:

In file included from mmotm-2008-1230-1605/drivers/leds/leds-dac124s085.c:16:
mmotm-2008-1230-1605/include/linux/spi/spi.h:66: error: field 'dev' has incomplete type
mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'to_spi_device':
mmotm-2008-1230-1605/include/linux/spi/spi.h:100: warning: type defaults to 'int' in declaration of '__mptr'
mmotm-2008-1230-1605/include/linux/spi/spi.h:100: warning: initialization from incompatible pointer type
mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_dev_get':
mmotm-2008-1230-1605/include/linux/spi/spi.h:106: error: implicit declaration of function 'get_device'
mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_dev_put':
mmotm-2008-1230-1605/include/linux/spi/spi.h:112: error: implicit declaration of function 'put_device'
mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_set_drvdata':
mmotm-2008-1230-1605/include/linux/spi/spi.h:130: error: implicit declaration of function 'dev_set_drvdata'
mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_get_drvdata':
mmotm-2008-1230-1605/include/linux/spi/spi.h:135: error: implicit declaration of function 'dev_get_drvdata'
mmotm-2008-1230-1605/include/linux/spi/spi.h:135: warning: return makes pointer from integer without a cast
mmotm-2008-1230-1605/include/linux/spi/spi.h: At top level:
mmotm-2008-1230-1605/include/linux/spi/spi.h:172: error: expected declaration specifiers or '...' before 'pm_message_t'
mmotm-2008-1230-1605/include/linux/spi/spi.h:174: error: field 'driver' has incomplete type
mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'to_spi_driver':
mmotm-2008-1230-1605/include/linux/spi/spi.h:179: warning: type defaults to 'int' in declaration of '__mptr'
mmotm-2008-1230-1605/include/linux/spi/spi.h:179: warning: initialization from incompatible pointer type
mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_unregister_driver':
mmotm-2008-1230-1605/include/linux/spi/spi.h:192: error: implicit declaration of function 'driver_unregister'
mmotm-2008-1230-1605/include/linux/spi/spi.h: At top level:
mmotm-2008-1230-1605/include/linux/spi/spi.h:225: error: field 'dev' has incomplete type
mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_master_get_devdata':
mmotm-2008-1230-1605/include/linux/spi/spi.h:271: warning: return makes pointer from integer without a cast
mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_message_alloc':
mmotm-2008-1230-1605/include/linux/spi/spi.h:494: error: implicit declaration of function 'kzalloc'
mmotm-2008-1230-1605/include/linux/spi/spi.h:496: warning: assignment makes pointer from integer without a cast
mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_message_free':
mmotm-2008-1230-1605/include/linux/spi/spi.h:510: error: implicit declaration of function 'kfree'
mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_unregister_device':
mmotm-2008-1230-1605/include/linux/spi/spi.h:801: error: implicit declaration of function 'device_unregister'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: David Brownell <dbrownell@users.sourceforge.net>
---
 include/linux/spi/spi.h |    2 ++
 1 file changed, 2 insertions(+)

--- mmotm-2008-1230-1605.orig/include/linux/spi/spi.h
+++ mmotm-2008-1230-1605/include/linux/spi/spi.h
@@ -19,6 +19,8 @@
 #ifndef __LINUX_SPI_H
 #define __LINUX_SPI_H
 
+#include <linux/device.h>
+
 /*
  * INTERFACES between SPI master-side drivers and SPI infrastructure.
  * (There's no SPI slave support for Linux yet...)
