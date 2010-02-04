Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab0BDUMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:12:08 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:16972 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab0BDUMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:12:05 -0500
Message-ID: <4B6B29DD.7060502@oracle.com>
Date: Thu, 04 Feb 2010 12:11:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       khali@linux-fr.org
Subject: [PATCH -next] i2c: fix xiic build error
References: <20100204185736.6628ab9a.sfr@canb.auug.org.au>
In-Reply-To: <20100204185736.6628ab9a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B6B2A05.01AA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add header file to fix build error:

drivers/i2c/busses/i2c-xiic.c:493: error: implicit declaration of function 'mdelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
  drivers/i2c/busses/i2c-xiic.c |    1 +
  1 file changed, 1 insertion(+)

--- linux-next-20100204.orig/drivers/i2c/busses/i2c-xiic.c
+++ linux-next-20100204/drivers/i2c/busses/i2c-xiic.c
@@ -31,6 +31,7 @@
  #include <linux/module.h>
  #include <linux/init.h>
  #include <linux/errno.h>
+#include <linux/delay.h>
  #include <linux/platform_device.h>
  #include <linux/i2c.h>
  #include <linux/interrupt.h>
