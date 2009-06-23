Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbZFWHOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbZFWHOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbZFWHOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:14:09 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:42328 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbZFWHOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:14:09 -0400
From: Len Brown <lenb@kernel.org>
To: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org
Subject: [RFC/PATCH 2.6.32] Simple Firmware Interface (SFI): initial support
Date: Tue, 23 Jun 2009 03:13:58 -0400
Message-id: <1245741246-6503-1-git-send-email-lenb@kernel.org>
X-Mailer: git-send-email 1.6.3.3.334.g916e1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains the initial SFI support for Linux.

You can read about SFI on its home page: http://simplefirmware.org

The latest SFI test patch is available in git:
git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git sfi-test

A consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/sfi/patches/2.6.30/-2.6.30.diff.gz

Diffstat for this series:

 Documentation/kernel-parameters.txt |    5 +
 MAINTAINERS                         |   12 +
 arch/x86/Kconfig                    |    4 +-
 arch/x86/include/asm/io_apic.h      |    4 +-
 arch/x86/kernel/Makefile            |    1 +
 arch/x86/kernel/apic/io_apic.c      |    4 +-
 arch/x86/kernel/e820.c              |    5 +
 arch/x86/kernel/setup.c             |    3 +
 arch/x86/kernel/sfi.c               |  335 +++++++++++++++++++++++++++++
 arch/x86/pci/mmconfig-shared.c      |    4 +-
 drivers/Makefile                    |    1 +
 drivers/acpi/tables.c               |    3 +
 drivers/sfi/Kconfig                 |   16 ++
 drivers/sfi/Makefile                |    3 +
 drivers/sfi/sfi_acpi.c              |   94 ++++++++
 drivers/sfi/sfi_core.c              |  403 +++++++++++++++++++++++++++++++++++
 drivers/sfi/sfi_core.h              |   63 ++++++
 include/acpi/acpi_drivers.h         |    3 +
 include/linux/acpi.h                |    5 +-
 include/linux/sfi.h                 |  161 ++++++++++++++
 include/linux/sfi_acpi.h            |   56 +++++
 init/main.c                         |    2 +
 22 files changed, 1179 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/kernel/sfi.c
 create mode 100644 drivers/sfi/Kconfig
 create mode 100644 drivers/sfi/Makefile
 create mode 100644 drivers/sfi/sfi_acpi.c
 create mode 100644 drivers/sfi/sfi_core.c
 create mode 100644 drivers/sfi/sfi_core.h
 create mode 100644 include/linux/sfi.h
 create mode 100644 include/linux/sfi_acpi.h

commits:

Feng Tang (7):
      SFI: include/linux/sfi.h
      SFI: core support
      SFI: Hook boot-time initialization
      SFI: Hook e820 memory map initialization
      SFI: add ACPI extensions
      SFI, PCI: Hook MMCONFIG
      SFI: expose IO-APIC routines to SFI, not just ACPI

Len Brown (1):
      SFI: Simple Firmware Interface - new Linux sub-system

