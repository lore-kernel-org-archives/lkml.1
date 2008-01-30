Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbYA3LwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbYA3LwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 06:52:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbYA3Lvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 06:51:53 -0500
Received: from ozlabs.org ([203.10.76.45]:53281 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbYA3Lvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:51:52 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] lguest updates (non-virtio changes)
Date: Wed, 30 Jan 2008 22:51:49 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801302251.49290.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 85004cc367abc000aa36c0d0e270ab609a68b0cb:
  Linus Torvalds (1):
        Merge git://git.linux-nfs.org/pub/linux/nfs-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus master

Balaji Rao (1):
      lguest: Reboot support

Glauber de Oliveira Costa (26):
      lguest: fix drivers/lguest Makefile entry
      lguest: remove pv_info dependency
      lguest: introduce vcpu struct
      lguest: adapt launcher to per-cpuness
      lguest: initialize vcpu
      lguest: per-cpu run guest
      lguest: make write() operation smp aware
      lguest: make hypercalls use the vcpu struct
      lguest: per-vcpu lguest timers
      lguest: per-vcpu interrupt processing.
      lguest: map_switcher_in_guest() per-vcpu
      lguest: make emulate_insn receive a vcpu struct.
      lguest: make registers per-vcpu
      lguest: replace lguest_arch with lg_cpu_arch.
      lguest: per-vcpu lguest task management
      lguest: makes special fields be per-vcpu
      lguest: make pending notifications per-vcpu
      lguest: per-vcpu lguest pgdir management
      lguest: change spte_addr header
      lguest: change last_guest to last_cpu
      lguest: move last_pages to lg_cpu
      lguest: move changed bitmap to lg_cpu
      lguest: change gpte_addr header
      lguest: get rid of lg variable assignments
      lguest: Use explicit includes rateher than indirect
      lguest: use __PAGE_KERNEL instead of _PAGE_KERNEL

 Documentation/lguest/lguest.c         |   49 ++++++++-
 arch/x86/lguest/boot.c                |   11 ++-
 drivers/Makefile                      |    2 +-
 drivers/lguest/core.c                 |   46 +++++----
 drivers/lguest/hypercalls.c           |  106 ++++++++++---------
 drivers/lguest/interrupts_and_traps.c |  149 ++++++++++++++--------------
 drivers/lguest/lg.h                   |  154 ++++++++++++++++-------------
 drivers/lguest/lguest_user.c          |  147 +++++++++++++++++----------
 drivers/lguest/page_tables.c          |  179 +++++++++++++++++----------------
 drivers/lguest/segments.c             |   48 +++++-----
 drivers/lguest/x86/core.c             |  127 ++++++++++++-----------
 include/asm-x86/lguest.h              |    2 +-
 include/asm-x86/lguest_hcall.h        |    6 +-
 13 files changed, 571 insertions(+), 455 deletions(-)
