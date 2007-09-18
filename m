Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbXIRJOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbXIRJOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbXIRJOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:14:40 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:35424 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbXIRJOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:14:39 -0400
Message-ID: <46EF96CC.1080807@linux.vnet.ibm.com>
Date: Tue, 18 Sep 2007 14:43:48 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
In-Reply-To: <20070918011841.2381bd93.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/
>
> 2.6.23-rc6-mm1 is a 29MB diff against 2.6.23-rc6.
>
>   
<snip>

Hi Andrew,

The 2.6.23-rc6-mm1build fails at

  CC      drivers/pci/hotplug/rpadlpar_core.o
  CC      drivers/pci/hotplug/rpadlpar_sysfs.o
drivers/pci/hotplug/rpadlpar_sysfs.c:132: error: unknown field `name' specified in initializer
drivers/pci/hotplug/rpadlpar_sysfs.c: In function `dlpar_sysfs_init':
drivers/pci/hotplug/rpadlpar_sysfs.c:142: error: structure has no member named `name'
make[3]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
make[2]: *** [drivers/pci/hotplug] Error 2
make[1]: *** [drivers/pci] Error 2
make: *** [drivers] Error 2

-- 

Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

