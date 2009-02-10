Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbZBJUHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbZBJUHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbZBJUH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:07:26 -0500
Received: from gw.goop.org ([64.81.55.164]:50700 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZBJUH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:07:26 -0500
Message-Id: <cover.1234296039.git.jeremy.fitzhardinge@citrix.com>
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Tue, 10 Feb 2009 12:00:39 -0800
Subject: [PATCH] *** SUBJECT HERE ***
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This series of patches (against tip/x86/apic) makes some fairly
uncontroversial changes and cleanups to lay the groundwork for some more
Xen-specific patches (which will no doubt cause more of a discussion).

These changes can also be pulled from
   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git x86/apic

Thanks,
	J

Ian Campbell (1):
  xen: expose enable_IO_APIC for 32-bit

Jeremy Fitzhardinge (4):
  x86: make apic_* operations inline functions
  x86: unstatic mp_find_ioapic so it can be used elsewhere
  x86: add mp_find_ioapic_pin
  x86: unstatic ioapic entry funcs

 arch/x86/include/asm/apic.h    |   35 +++++++++++++++++++++++++++++------
 arch/x86/include/asm/hw_irq.h  |    2 --
 arch/x86/include/asm/io_apic.h |    6 ++++++
 arch/x86/include/asm/mpspec.h  |    2 ++
 arch/x86/kernel/acpi/boot.c    |   18 ++++++++++++++----
 arch/x86/kernel/io_apic.c      |   10 +++++-----
 6 files changed, 56 insertions(+), 17 deletions(-)

