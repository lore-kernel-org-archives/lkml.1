Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbYCQTl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbYCQTl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 15:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbYCQTlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 15:41:52 -0400
Received: from www17.your-server.de ([213.133.104.17]:34661 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbYCQTlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 15:41:51 -0400
Message-ID: <47DEC970.2050402@m3y3r.de>
Date: Mon, 17 Mar 2008 20:41:36 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080310)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, htejun@gmail.com,
       jeff@garzik.org
Subject: In function `ata_acpi_associate': undefined reference to `register_hotplug_dock_device'
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ git describe
v2.6.25-rc6-14-gbde4f8f

$ make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: modpost: Found 14 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `ata_acpi_associate':
(.text+0x7106a): undefined reference to `register_hotplug_dock_device'
drivers/built-in.o: In function `ata_acpi_associate':
(.text+0x710bd): undefined reference to `register_hotplug_dock_device'
make: *** [.tmp_vmlinux1] Fehler 1


