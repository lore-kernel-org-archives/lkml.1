Return-Path: <linux-kernel-owner+w=401wt.eu-S1761335AbYBBNYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335AbYBBNYj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 08:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYBBNYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 08:24:30 -0500
Received: from senator.holtmann.net ([87.106.208.187]:41800 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYBBNY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 08:24:29 -0500
Subject: ACPI problem on PowerPC
From: Marcel Holtmann <marcel@holtmann.org>
To: Greg KH <gregkh@suse.de>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Sat, 02 Feb 2008 14:24:44 +0100
Message-Id: <1201958684.15090.42.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

the following happens with the latest ACPI and PCI merges on my Quad G5:

  CC      drivers/pci/pcie/aspm.o
In file included from include/acpi/platform/acenv.h:140,
                 from include/acpi/acpi.h:54,
                 from include/acpi/acpi_bus.h:31,
                 from drivers/pci/pcie/aspm.c:20:
include/acpi/platform/aclinux.h:59:22: error: asm/acpi.h: No such file or directory
In file included from include/acpi/platform/aclinux.h:120,
                 from include/acpi/platform/acenv.h:140,
                 from include/acpi/acpi.h:54,
                 from include/acpi/acpi_bus.h:31,
                 from drivers/pci/pcie/aspm.c:20:
include/acpi/actypes.h:130: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘UINT64’
include/acpi/actypes.h:131: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘INT64’
include/acpi/actypes.h:753: error: expected ‘)’ before ‘*’ token
include/acpi/actypes.h:756: error: expected ‘)’ before ‘*’ token
In file included from include/acpi/acpi.h:61,
                 from include/acpi/acpi_bus.h:31,
                 from drivers/pci/pcie/aspm.c:20:
include/acpi/acpiosxf.h:178: error: expected declaration specifiers or ‘...’ before ‘acpi_osd_handler’
include/acpi/acpiosxf.h:182: error: expected declaration specifiers or ‘...’ before ‘acpi_osd_handler’
include/acpi/acpiosxf.h:191: error: expected declaration specifiers or ‘...’ before ‘acpi_osd_exec_callback’
make[3]: *** [drivers/pci/pcie/aspm.o] Error 1
make[2]: *** [drivers/pci/pcie] Error 2
make[1]: *** [drivers/pci] Error 2
make: *** [drivers] Error 2

The Quad G5 has PCI Express, but I am not sure about the ASPM support.
Obviously I enabled CONFIG_PCIEASPM.

Regards

Marcel


