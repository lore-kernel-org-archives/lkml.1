Return-Path: <linux-kernel-owner+w=401wt.eu-S1760104AbZIPVGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104AbZIPVGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbZIPVGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:06:31 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57617 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754766AbZIPVGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:06:30 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v3 0/5] Linker script cleanup patches for x86
Date: Wed, 16 Sep 2009 16:44:25 -0400
Message-Id: <1253133870-25140-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of the patch series I sent on September 8
cleaning up the x86 architecture's linker scripts.  The only change is
that it is rebased on top of Linus's current master.

This cross-architecture linker script cleanup project is in
preparation for adding support for building the kernel with
-ffunction-sections -fdata-sections, which is a prerequisite for
Ksplice.

	-Tim Abbott

Anders Kaseorg (1):
  x86: fix fragile computation of vsyscall address

Tim Abbott (4):
  x86: convert compressed loader to use __HEAD and HEAD_TEXT macros.
  x86: convert to use __HEAD and HEAD_TEXT macros.
  x86: Use section .data.page_aligned for the idt_table.
  x86: Cleanup linker script using new linker script macros.

 arch/x86/boot/compressed/head_32.S     |    3 +-
 arch/x86/boot/compressed/head_64.S     |    3 +-
 arch/x86/boot/compressed/vmlinux.lds.S |    6 ++-
 arch/x86/kernel/head_32.S              |    2 +-
 arch/x86/kernel/head_64.S              |    2 +-
 arch/x86/kernel/traps.c                |    6 +--
 arch/x86/kernel/vmlinux.lds.S          |   79 +++++--------------------------
 7 files changed, 25 insertions(+), 76 deletions(-)

