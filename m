Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYCWBnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYCWBnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 21:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbYCWBnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 21:43:01 -0400
Received: from bay0-omc3-s40.bay0.hotmail.com ([65.54.246.240]:41155 "EHLO
	bay0-omc3-s40.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331AbYCWBnA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 21:43:00 -0400
Message-ID: <BAY101-W56F344A741AF8E16D0E80AC8030@phx.gbl>
X-Originating-IP: [99.140.203.94]
From: Adam Turk <bofh1234@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: warnings during compile and boot
Date: Sat, 22 Mar 2008 21:43:00 -0400
Importance: Normal
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 23 Mar 2008 01:43:00.0352 (UTC) FILETIME=[3A1D2000:01C88C87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I just compiled 2.6.25-rc6 and got a bunch of warnings which are annoying.  I also see new informational warnings during boot:
driver 'sd' needs updating - please use bus_type methods
driver 'sr' needs updating - please use bus_type methods

warnings:
  CC      kernel/power/pm.o
kernel/power/pm.c:203: warning: 'pm_register' is deprecated (declared at kernel/power/pm.c:62)
kernel/power/pm.c:203: warning: 'pm_register' is deprecated (declared at kernel/power/pm.c:62)
kernel/power/pm.c:204: warning: 'pm_send_all' is deprecated (declared at kernel/power/pm.c:178)
kernel/power/pm.c:204: warning: 'pm_send_all' is deprecated (declared at kernel/power/pm.c:178)
  CC      kernel/power/process.o


 CC [M]  fs/cifs/connect.o
  CC [M]  fs/cifs/dir.o
fs/cifs/dir.c: In function 'cifs_ci_compare':
fs/cifs/dir.c:582: warning: passing argument 1 of '__constant_memcpy' discards qualifiers from pointer target type
fs/cifs/dir.c:582: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC [M]  fs/cifs/file.o

  CC      fs/partitions/check.o
fs/partitions/check.c: In function 'add_partition':
fs/partitions/check.c:381: warning: ignoring return value of 'device_add', declared with attribute warn_unused_result

 CC      drivers/message/i2o/device.o
drivers/message/i2o/device.c: In function 'i2o_device_add':
drivers/message/i2o/device.c:247: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
drivers/message/i2o/device.c:254: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
drivers/message/i2o/device.c:260: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
drivers/message/i2o/device.c:267: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result


  CC      drivers/pci/search.o
drivers/pci/search.c: In function 'pci_find_slot':
drivers/pci/search.c:135: warning: 'pci_find_device' is deprecated (declared at include/linux/pci.h:506)
drivers/pci/search.c: At top level:
drivers/pci/search.c:478: warning: 'pci_find_device' is deprecated (declared at drivers/pci/search.c:283)
drivers/pci/search.c:478: warning: 'pci_find_device' is deprecated (declared at drivers/pci/search.c:283)
drivers/pci/search.c:479: warning: 'pci_find_slot' is deprecated (declared at drivers/pci/search.c:132)
drivers/pci/search.c:479: warning: 'pci_find_slot' is deprecated (declared at drivers/pci/search.c:132)

Just an FYI,

_________________________________________________________________
How well do you know your celebrity gossip?
http://originals.msn.com/thebigdebate?ocid=T002MSN03N0707A