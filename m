Return-Path: <linux-kernel-owner+w=401wt.eu-S1765976AbZBNBtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765976AbZBNBtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763042AbZBNBoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:44:00 -0500
Received: from gw.goop.org ([64.81.55.164]:51052 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932705AbZBNBn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:43:58 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 0/9] *** SUBJECT HERE ***
Date: Fri, 13 Feb 2009 17:11:58 -0800
Message-Id: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

*** BLURB HERE ***

Ian Campbell (1):
  xen: pre-initialize legacy irqs early

Jeremy Fitzhardinge (8):
  xen/dom0: handle acpi lapic parsing in Xen dom0
  xen: hook io_apic read/write operations
  xen: create dummy ioapic mapping
  xen: implement pirq type event channels
  x86/io_apic: add get_nr_irqs_gsi()
  xen/apic: identity map gsi->irqs
  xen: direct irq registration to pirq event channels
  xen: bind pirq to vector and event channel

 arch/x86/include/asm/io_apic.h |    7 +
 arch/x86/include/asm/xen/pci.h |   13 ++
 arch/x86/kernel/acpi/boot.c    |   18 +++-
 arch/x86/kernel/io_apic.c      |   37 +++++-
 arch/x86/xen/Kconfig           |   11 ++
 arch/x86/xen/Makefile          |    4 +-
 arch/x86/xen/apic.c            |   57 +++++++++
 arch/x86/xen/enlighten.c       |    2 +
 arch/x86/xen/mmu.c             |   10 ++
 arch/x86/xen/pci.c             |   81 +++++++++++++
 arch/x86/xen/xen-ops.h         |    6 +
 drivers/xen/events.c           |  260 +++++++++++++++++++++++++++++++++++++++-
 include/xen/events.h           |   22 ++++
 13 files changed, 520 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/pci.h
 create mode 100644 arch/x86/xen/apic.c
 create mode 100644 arch/x86/xen/pci.c

