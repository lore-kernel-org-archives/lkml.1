Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbXLMPQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbXLMPQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761870AbXLMPQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:16:35 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:57755 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761537AbXLMPQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:16:32 -0500
Message-ID: <47614CB2.40803@linux.vnet.ibm.com>
Date: Thu, 13 Dec 2007 20:46:02 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc5-mm1 - build failures due to kobject changes
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
In-Reply-To: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails, due to kobjects changes

drivers/infiniband/hw/ehca/ehca_main.c: In function ‘ehca_module_init’:
drivers/infiniband/hw/ehca/ehca_main.c:947: error: ‘struct device_driver’ has no member named ‘kobj’
drivers/infiniband/hw/ehca/ehca_main.c: In function ‘ehca_module_exit’:
drivers/infiniband/hw/ehca/ehca_main.c:976: error: ‘struct device_driver’ has no member named ‘kobj’
make[3]: *** [drivers/infiniband/hw/ehca/ehca_main.o] Error 1
make[2]: *** [drivers/infiniband/hw/ehca] Error 2
make[1]: *** [drivers/infiniband] Error 2
make: *** [drivers] Error 2


drivers/net/ehea/ehea_main.c: In function ‘ehea_driver_sysfs_add’:
drivers/net/ehea/ehea_main.c:2812: error: ‘struct device_driver’ has no member named ‘kobj’
drivers/net/ehea/ehea_main.c:2815: error: ‘struct device_driver’ has no member named ‘kobj’
drivers/net/ehea/ehea_main.c:2818: error: ‘struct device_driver’ has no member named ‘kobj’
drivers/net/ehea/ehea_main.c: In function ‘ehea_driver_sysfs_remove’:
drivers/net/ehea/ehea_main.c:2830: error: ‘struct device_driver’ has no member named ‘kobj’
make[3]: *** [drivers/net/ehea/ehea_main.o] Error 1
make[2]: *** [drivers/net/ehea] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2


  CC      drivers/net/iseries_veth.o
drivers/net/iseries_veth.c: In function ‘veth_module_init’:
drivers/net/iseries_veth.c:1714: error: ‘struct device_driver’ has no member named ‘kobj’
make[2]: *** [drivers/net/iseries_veth.o] Error 1
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
