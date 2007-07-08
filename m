Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbXGHLyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbXGHLyz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbXGHLyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:54:45 -0400
Received: from il.qumranet.com ([82.166.9.18]:38356 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbXGHLyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/20] KVM updates for 2.6.23, part 2
Date: Sun,  8 Jul 2007 14:54:29 +0300
Message-Id: <11838956891287-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second set of updates for the 2.6.23 merge window.  This time
around, the patchset includes the cpu hotplug fixes (which also make
suspend and resume robust in the presence of running virtual machines). Also
included are a few fixes and core updates.

Avi Kivity (11):
      KVM: VMX: Reinitialize the real-mode tss when entering real mode
      KVM: VMX: Remove unnecessary code in vmx_tlb_flush()
      KVM: Remove kvmfs in favor of the anonymous inodes source
      KVM: Clean up #includes
      HOTPLUG: Add CPU_DYING notifier
      HOTPLUG: Adapt cpuset hotplug callback to CPU_DYING
      HOTPLUG: Adapt thermal throttle to CPU_DYING
      SMP: Implement on_cpu()
      KVM: Keep track of which cpus have virtualization enabled
      KVM: Tune hotplug/suspend IPIs
      KVM: Use CPU_DYING for disabling virtualization

Eddie Dong (1):
      KVM: Add support for in-kernel pio handlers

Gregory Haskins (2):
      KVM: Adds support for in-kernel mmio handlers
      KVM: VMX: Fix interrupt checking on lightweight exit

Joerg Roedel (1):
      KVM: SVM: Reliably detect if SVM was disabled by BIOS

Luca Tettamanti (2):
      KVM: Fix x86 emulator writeback
      KVM: Avoid useless memory write when possible

Nitin A Kamble (2):
      KVM: Implement emulation of "pop reg" instruction (opcode 0x58-0x5f)
      KVM: Implement emulation of instruction "ret" (opcode 0xc3)

Shaohua Li (1):
      KVM: MMU: Fix Wrong tlb flush order

