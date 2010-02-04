Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab0BDUN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:13:59 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:61598 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab0BDUN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:13:57 -0500
Message-ID: <4B6B2A27.9070600@oracle.com>
Date: Thu, 04 Feb 2010 12:12:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH -next] pci hotplug: fix ibmphp build error
References: <20100204185736.6628ab9a.sfr@canb.auug.org.au>
In-Reply-To: <20100204185736.6628ab9a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B6B2A7F.005D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add header file to fix build error:

drivers/pci/hotplug/ibmphp_hpc.c:135: error: implicit declaration of function 'init_MUTEX'
drivers/pci/hotplug/ibmphp_hpc.c:136: error: implicit declaration of function 'init_MUTEX_LOCKED'
drivers/pci/hotplug/ibmphp_hpc.c:797: error: implicit declaration of function 'down'
drivers/pci/hotplug/ibmphp_hpc.c:807: error: implicit declaration of function 'up'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
  drivers/pci/hotplug/ibmphp_hpc.c |    1 +
  1 file changed, 1 insertion(+)

--- linux-next-20100204.orig/drivers/pci/hotplug/ibmphp_hpc.c
+++ linux-next-20100204/drivers/pci/hotplug/ibmphp_hpc.c
@@ -35,6 +35,7 @@
  #include <linux/init.h>
  #include <linux/mutex.h>
  #include <linux/sched.h>
+#include <linux/semaphore.h>
  #include <linux/kthread.h>
  #include "ibmphp.h"
  
