Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbZBVAA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbZBVAA7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZBVAAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:00:50 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:49361 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbZBVAAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:00:49 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 00/16] fix sparse warnings: Using plain integer as NULL pointer
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Feb 2009 01:00:43 +0100
Message-ID: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fix the sparse warning 'Using plain integer as
NULL pointer' all over the kernel tree.  This series is based on
linux-next/next-20090220.

---

Hannes Eder (16):
      ALSA: msnd: fix sparse warning: Using plain integer as NULL pointer
      ipv6: fix sparse warning: Using plain integer as NULL pointer
      memcg: fix sparse warning: Using plain integer as NULL pointer
      kprobes: fix sparse warnings: Using plain integer as NULL pointer
      reiserfs: fix sparse warning: Using plain integer as NULL pointer
      fs/super.c: fix sparse warning: Using plain integer as NULL pointer
      viafb: fix sparse warning: Using plain integer as NULL pointer
      usb host: fix sparse warning: Using plain integer as NULL pointer
      [SCSI] FlashPoint: fix sparse warnings: Using plain integer as NULL pointer
      panasonic-laptop: fix sparse warning: Using plain integer as NULL pointer
      MTD: tests: fix sparse warnings: Using plain integer as NULL pointer
      dvb: fix sparse warnings: Using plain integer as NULL pointer
      ide: fix sparse warnings: Using plain integer as NULL pointer
      drm: radeon: fix sparse warnings: Using plain integer as NULL pointer
      x86, numa_32.c: fix sparse warning: Using plain integer as NULL pointer
      kexec/i386: fix sparse warnings: Using plain integer as NULL pointer


 arch/x86/kernel/machine_kexec_32.c      |    2 +-
 arch/x86/kernel/traps.c                 |    2 +-
 arch/x86/mm/numa_32.c                   |    2 +-
 drivers/gpu/drm/radeon/radeon_cp.c      |    2 +-
 drivers/gpu/drm/radeon/radeon_state.c   |    2 +-
 drivers/ide/ide-disk_proc.c             |    2 +-
 drivers/ide/ide-floppy_proc.c           |    2 +-
 drivers/ide/ide-proc.c                  |    2 +-
 drivers/ide/ide-tape.c                  |    2 +-
 drivers/media/dvb/frontends/drx397xD.c  |    2 +-
 drivers/mtd/tests/mtd_oobtest.c         |   24 ++++++++++++------------
 drivers/mtd/tests/mtd_readtest.c        |    2 +-
 drivers/platform/x86/panasonic-laptop.c |    2 +-
 drivers/scsi/FlashPoint.c               |    7 +++----
 drivers/usb/host/oxu210hp-hcd.c         |    2 +-
 drivers/video/via/hw.c                  |    2 +-
 fs/reiserfs/inode.c                     |    2 +-
 fs/super.c                              |    2 +-
 kernel/test_kprobes.c                   |    6 +++---
 mm/memcontrol.c                         |    2 +-
 net/ipv6/xfrm6_state.c                  |    2 +-
 sound/isa/msnd/msnd_pinnacle.c          |    2 +-
 22 files changed, 37 insertions(+), 38 deletions(-)
