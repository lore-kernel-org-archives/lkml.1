Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbYCAUnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbYCAUnT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 15:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbYCAUnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 15:43:01 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:21515 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYCAUnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 15:43:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ae3A7TdMaqAjehNXWgi+pMaq8D8RJDR++i3t193P/uDbaWhZZlmgY3nSvbvVu3Dg/aHFP9RityRLFvYXD/IsHpfOQ5LhFGQBhV5XWdOjj+5Up24UdvCl352qVj+eqSdvTor/YgLWu+Hd4Tdl9bk7YnCZjeCx4pUyju/V02+/d1Y=
Message-ID: <ecb4efd10803011242w3874d27eyb1afaea06766bdbf@mail.gmail.com>
Date: Sat, 1 Mar 2008 15:42:58 -0500
From: "Clem Taylor" <clem.taylor@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: e1000 driver not loading in 2.6.24.3 on x86_64 (worked in 2.6.24-rc7)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to move from 2.6.24-rc7 to 2.6.24.3 on a x86_64 desktop
machine. With 2.6.24.3, the e1000 driver (compiled in, not a module)
does not claim the device. In 2.6.24-rc7 it works just fine.

The ethernet device shows up in lspci in both kernels, but the driver
doesn't seem to probe the card in 2.6.24.3

2.6.24-rc7:
loop: module loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:04:00.0 to 64
e1000: 0000:04:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:16:76:c9:33>
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
e1000e: Copyright (c) 1999-2007 Intel Corporation.
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2

2.6.24.3:
loop: module loaded
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
e1000e: Copyright (c) 1999-2007 Intel Corporation.
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2

There were a few minor configuration changes between the two kernels
(added ACPI_SYSFS_POWER, removed ACPI_PROC_EVENT) but nothing I would
think that prevent the e1000 driver from loading.

                                          Any ideas?
                                          Clem
