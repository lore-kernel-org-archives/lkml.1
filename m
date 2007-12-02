Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbXLBLSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbXLBLSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 06:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXLBLSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 06:18:07 -0500
Received: from il.qumranet.com ([82.166.9.18]:41418 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbXLBLSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 06:18:06 -0500
From: Avi Kivity <avi@qumranet.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 00/10]: KVM updates for 2.6.23.9 (-stable)
Date: Sun,  2 Dec 2007 13:18:37 +0200
Message-Id: <1196594327338-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset fixes some bugs in KVM for the next 2.6.23.y stable
release.  Please apply.

Amit Shah (2):
      KVM: x86 emulator: Use emulator_write_emulated and not emulator_write_std
      KVM: SVM: Fix FPU leak while emulating clts

Aurelien Jarno (1):
      KVM: x86 emulator: fix access registers for instructions with ModR/M byte and Mod = 3

Avi Kivity (4):
      KVM: x86 emulator: invd instruction
      KVM: SVM: Intercept the 'invd' and 'wbinvd' instructions
      KVM: Skip pio instruction when it is emulated, not executed
      KVM: VMX: Force vm86 mode if setting flags during real mode

Eddie Dong (1):
      KVM: VMX: Reset mmu context when entering real mode

Marko Kohtala (1):
      KVM: Fix hang on uniprocessor

Sheng Yang (1):
      KVM: x86 emulator: implement 'movnti mem, reg'


 drivers/kvm/kvm_main.c    |   16 ++++++++++------
 drivers/kvm/mmu.c         |    1 +
 drivers/kvm/svm.c         |    4 ++++
 drivers/kvm/vmx.c         |    3 +++
 drivers/kvm/x86_emulate.c |   30 +++++++++++++++++++++++++++---
 5 files changed, 45 insertions(+), 9 deletions(-)
