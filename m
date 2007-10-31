Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbXJaITk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbXJaITk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 04:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbXJaIT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 04:19:26 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:52400 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbXJaITZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 04:19:25 -0400
Message-ID: <47283A53.6060800@linux.vnet.ibm.com>
Date: Wed, 31 Oct 2007 13:48:27 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: [BUILD-FAILURE] 2.6.24-rc1-git8 build fails drivers/pci/probe.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The 2.6.24-rc-git8 build fails with build error

  CC      drivers/pci/probe.o
drivers/pci/probe.c: In function 'pci_create_legacy_files':
drivers/pci/probe.c:56: error: implicit declaration of function 'class_device_create_bin_file'
drivers/pci/probe.c: In function 'pci_remove_legacy_files':
drivers/pci/probe.c:71: error: implicit declaration of function 'class_device_remove_bin_file'
make[2]: *** [drivers/pci/probe.o] Error 1
make[1]: *** [drivers/pci] Error 2
make: *** [drivers] Error 2

This is caused by the commit fcd239d3d5575e5cc63aab5c33cf6dc66904f6d6 (Driver core: remove class_device_*_bin_file).
These functions are still being used by drivers/pci/probe.c.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
