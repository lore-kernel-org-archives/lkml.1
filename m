Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab0BVTLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:11:10 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:25767 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab0BVTLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:11:07 -0500
Subject: [PATCH v2 00/12] ACPI: processor driver vs. core
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Feb 2010 12:11:03 -0700
Message-ID: <20100222190145.19752.20978.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original thread:
	http://thread.gmane.org/gmane.linux.kernel/942423

Refreshed against lenb/test (a0eb5a84da383539f11e777bdde5e69a31ed25c7)

Added Venki's Acked-by.

The first patch has lots of legacy checkpatch warnings/errors, and
I have another series to clean those up after this series is applied.

Thanks,
/ac

---

Alex Chiang (12):
      ACPI: processor: mv processor_core.c processor_driver.c
      ACPI: processor: mv processor_pdc.c processor_core.c
      ACPI: processor: export acpi_get_cpuid()
      ACPI: processor: move acpi_get_cpuid into processor_core.c
      ACPI: processor: add internal processor_physically_present()
      ACPI: processor: remove early _PDC optin quirks
      ACPI: processor: driver doesn't need to evaluate _PDC
      ACPI: processor: refactor internal map_lapic_id()
      ACPI: processor: refactor internal map_x2apic_id()
      ACPI: processor: refactor internal map_lsapic_id()
      ACPI: processor: push file static MADT pointer into internal map_madt_entry()
      ACPI: processor core: style and sparse cleanups


 Documentation/kernel-parameters.txt |    4 
 arch/ia64/kernel/acpi.c             |    3 
 arch/x86/kernel/acpi/boot.c         |    3 
 drivers/acpi/Makefile               |    4 
 drivers/acpi/processor_core.c       | 1149 +++++------------------------------
 drivers/acpi/processor_driver.c     |  976 ++++++++++++++++++++++++++++++
 drivers/acpi/processor_pdc.c        |  209 ------
 include/acpi/processor.h            |   10 
 8 files changed, 1172 insertions(+), 1186 deletions(-)
 create mode 100644 drivers/acpi/processor_driver.c
 delete mode 100644 drivers/acpi/processor_pdc.c

