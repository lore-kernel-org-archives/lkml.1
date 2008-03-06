Return-Path: <linux-kernel-owner+w=401wt.eu-S1765559AbYCFSv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765559AbYCFSv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762673AbYCFSvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:51:16 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:39671 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759335AbYCFSvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:51:14 -0500
Subject: [PATCH 0/5] 2.6.25-rc3-mm1 hotplug memory remove updates
From: Badari Pulavarty <pbadari@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, pbadari@us.ibm.com
Content-Type: text/plain
Date: Thu, 06 Mar 2008 10:54:33 -0800
Message-Id: <1204829673.7939.59.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew & Paul,

Here are the updates for hotplug memory remove. Most changes are
PPC specific, but I would like these to be included in next -mm 
for easy testing and review, before including in Paul's tree.

eHEA driver folks are verifying if the exported interface
walk_memory_resource() is good enough for their needs. And also,
we are verifying the code on x86_64. Once that is done, we may
be able to cleanup some of the code (make remove_memory() arch
generic).

We still have an issue with not being able to free up the allocations
that came from bootmem. Yasunori Goto wants to clean up that code.

[PATCH 1/5] generic __remove_pages() support
[PATCH 2/5] [PPC] htab_remove_mapping() error handling
[PATCH 3/5] [PPC] hotplug memory notifications for ppc
[PATCH 4/5] [PPC] update lmb for hotplug memory add/remove
[PATCH 5/5] [PPC] provide walk_memory_resource() for ppc

Testing: All the patches are tested on p-series LPAR configuration,
writing to /sysfs & /proc, through DLPAR tools and through HMC. 
Testing on x86_64 needs more work.

Thanks,
Badari

