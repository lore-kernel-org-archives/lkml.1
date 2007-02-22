Return-Path: <linux-kernel-owner+w=401wt.eu-S1751901AbXBVVPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbXBVVPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbXBVVPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:15:24 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:36055 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbXBVVPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:15:23 -0500
Date: Thu, 22 Feb 2007 22:15:22 +0100
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Andrew Morton <akpm@osdl.org>
Cc: len.brown@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.20-mm2 CONFIG_ACPI_BAY=y: undefined reference to `is_dock_device'
Message-ID: <20070222211522.GA6939@rhlx01.hs-esslingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

make-kpkg kernel_image bombed with:

  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `bay_is_dock_device':
drivers/acpi/bay.c:261: undefined reference to `is_dock_device'
drivers/acpi/bay.c:261: undefined reference to `is_dock_device'
drivers/built-in.o: In function `bay_add':
drivers/acpi/bay.c:308: undefined reference to `register_hotplug_dock_device'
drivers/built-in.o: In function `bay_exit':
drivers/acpi/bay.c:384: undefined reference to `is_dock_device'
drivers/acpi/bay.c:385: undefined reference to `unregister_hotplug_dock_device'
make[1]: *** [.tmp_vmlinux1] Error 1
make[1]: Leaving directory `/usr/src/linux-2.6.20-mm2'


Famous last words: CONFIG_ACPI_DOCK=m...

Andreas Mohr
