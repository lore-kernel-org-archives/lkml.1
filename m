Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab0BVQh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 11:37:29 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:36968 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab0BVQh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 11:37:28 -0500
Message-ID: <4B82B28F.10104@oracle.com>
Date: Mon, 22 Feb 2010 08:36:31 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: ben-linux@fluff.org
CC: Jean Delvare <khali@linux-fr.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] i2c: fix xiic build error
References: <20100204185736.6628ab9a.sfr@canb.auug.org.au>	<4B6B29DD.7060502@oracle.com>	<4B7AC2A9.4070203@oracle.com> <20100216173326.091c1c77@hyperion.delvare> <4B7AC999.3060103@oracle.com>
In-Reply-To: <4B7AC999.3060103@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B82B2AA.0174:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/10 08:36, Randy Dunlap wrote:
> On 02/16/10 08:33, Jean Delvare wrote:
>> Hi Randy,
>>
>> On Tue, 16 Feb 2010 08:07:05 -0800, Randy Dunlap wrote:
>>> On 02/04/10 12:11, Randy Dunlap wrote:
>>>
>>>
>>> This patch is still needed in linux-next-20100216.
>>
>> Nothing I can do about it, as the i2c-xiic driver is neither upstream
>> nor in my tree.
>>
> 
> Thanks, Jean.
> 
> Next/merge.log tells me:
> Merge remote branch 'bjdooks-i2c/next-i2c'
> 
> Ben??
> 

ping Ben.

Here's the patch again.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Add header file to fix build error:

drivers/i2c/busses/i2c-xiic.c:493: error: implicit declaration of function 'mdelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org
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
