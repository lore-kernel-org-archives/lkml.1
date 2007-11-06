Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbXKFPeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbXKFPeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 10:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbXKFPej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 10:34:39 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:45058 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbXKFPei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 10:34:38 -0500
Message-ID: <4730896A.9060701@linux.vnet.ibm.com>
Date: Tue, 06 Nov 2007 21:04:02 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: mm snapshot broken-out-2007-11-06-02-32.tar.gz uploaded - build
 failure - rpadlpar_sysfs
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
In-Reply-To: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The build fails with following error
 
  CC      drivers/pci/hotplug/rpadlpar_sysfs.o
drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: initializer element is not constant
drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: (near initialization for `dlpar_io_kset.kobj.parent')
drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: initializer element is not constant
drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: (near initialization for `dlpar_io_kset.kobj')
drivers/pci/hotplug/rpadlpar_sysfs.c:134: error: unknown field `ktype' specified in initializer
drivers/pci/hotplug/rpadlpar_sysfs.c:134: warning: initialization from incompatible pointer type
make[3]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
make[2]: *** [drivers/pci/hotplug] Error 2
make[1]: *** [drivers/pci] Error 2
make: *** [drivers] Error 2

The patch, gregkh-driver-kset-convert-pci-hotplug-to-use-kset_create_and_register.patch
is causing the build failure.
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
