Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbYC0XdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbYC0XdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbYC0XdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:33:16 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:45476 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbYC0XdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:33:15 -0400
Subject: [PATCH 0/5] 2.6.25-rc5-mm1 hotplug memory remove updates
From: Badari Pulavarty <pbadari@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 16:33:26 -0800
Message-Id: <1206664406.19368.2.camel@dyn9047017100.beaverton.ibm.com>
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


