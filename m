Return-Path: <linux-kernel-owner+w=401wt.eu-S1030520AbXHMMd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030520AbXHMMd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940038AbXHMG55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:57:57 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:59309 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939352AbXHMG54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:57:56 -0400
Message-ID: <46C00050.5090208@linux.vnet.ibm.com>
Date: Mon, 13 Aug 2007 12:25:12 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel 2.6.23-rc3 build fails
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The 2.6.23-rc3 kernel build fails with the following
error message,

=======================================================
Root device is (8, 1)
Setup is 10200 bytes (padded to 10240 bytes).
System is 2052 kB
Kernel: arch/x86_64/boot/bzImage is ready (#1)
08/12/07-22:39:51 Build the kernel. Succeeded
CHK include/linux/version.h
CHK include/linux/utsrelease.h
CALL scripts/checksyscalls.sh
CC [M] drivers/acpi/video.o
CC [M] drivers/net/8139cp.o
CC [M] drivers/net/8139too.o
CC [M] drivers/net/e1000/e1000_main.o
CC [M] drivers/net/e1000/e1000_hw.o
CC [M] drivers/net/e1000/e1000_ethtool.o
CC [M] drivers/net/e1000/e1000_param.o
LD [M] drivers/net/e1000/e1000.o
CC [M] drivers/scsi/ips.o
drivers/scsi/ips.c: In function `ips_register_scsi':
drivers/scsi/ips.c:6867: warning: ignoring return value of 
`scsi_add_host', declared with attribute warn_unused_result
CC [M] drivers/scsi/scsi_wait_scan.o
CC [M] drivers/video/output.o
Building modules, stage 2.
MODPOST 7 modules
FATAL: drivers/acpi/video: sizeof(struct acpi_device_id)=20 is not a 
modulo of the size of section __mod_acpi_device_table=48.
Fix definition of struct acpi_device_id in mod_devicetable.h
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Thanks,
Kamalesh Babulal

