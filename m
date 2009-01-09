Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbZAIPsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbZAIPsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 10:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbZAIPrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 10:47:52 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:36669 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbZAIPrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 10:47:51 -0500
X-BigFish: VPS-23(z21eW5edJz62a3L4015Mzzzzz32i6bh43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KD7NV4-02-6Z9-01
Date: Fri, 9 Jan 2009 16:47:33 +0100
From: Robert Richter <robert.richter@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT PULL] please pull oprofile updates for 2.6.29
Message-ID: <20090109154733.GX15411@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 Jan 2009 15:47:33.0719 (UTC) FILETIME=[966A4E70:01C97271]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the oprofile updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-linus

It contains a powerpc/cell update and cleanup and rework patches that
completes my ring_buffer implementation.

Thanks,

-Robert

The following changes since commit 2150edc6c5cf00f7adb54538b9ea2a3e9cedca3f:
  Linus Torvalds (1):
        Merge branch 'for_linus' of git://git.kernel.org/.../tytso/ext4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-linus

Carl Love (2):
      powerpc/oprofile: IBM CELL: cleanup and restructuring
      powerpc/oprofile: IBM CELL: add SPU event profiling support

Robert Richter (31):
      oprofile: rename kernel-wide identifiers
      oprofile: rename cpu buffer functions
      oprofile: remove ring buffer inline functions in cpu_buffer.h
      x86/oprofile: fix pci_dev use count for AMD northbridge devices
      oprofile: reordering some code in cpu_buffer.c
      oprofile: add inline function __oprofile_add_ext_sample()
      oprofile: simplify add_sample()
      oprofile: simplify sync_buffer()
      oprofile: simplify oprofile_begin_trace()
      oprofile: simplify add_sample() in cpu_buffer.c
      oprofile: simplify add_ibs_begin()
      oprofile: remove unused components in struct oprofile_cpu_buffer
      oprofile: remove unused ibs macro
      oprofile: remove backtrace code for ibs
      oprofile: making add_sample_entry() inline
      oprofile: rename variable ibs_allowed to has_ibs in op_model_amd.c
      oprofile: rename add_sample() in cpu_buffer.c
      oprofile: rename variables in add_ibs_begin()
      oprofile: add op_cpu_buffer_write_reserve()
      oprofile: modify op_cpu_buffer_read_entry()
      oprofile: rework implementation of cpu buffer events
      oprofile: add op_cpu_buffer_add_data()
      oprofile: add op_cpu_buffer_get_data()
      oprofile: use new data sample format for ibs
      ring_buffer: fix ring_buffer_event_length()
      oprofile: remove #ifdef CONFIG_OPROFILE_IBS in non-ibs code
      oprofile: make new cpu buffer functions part of the api
      Merge branch 'oprofile/ring_buffer' into oprofile/oprofile-for-tip
      powerpc/oprofile: fix cell/pr_util.h
      powerpc/oprofile: fix whitespaces in op_model_cell.c
      Merge branch 'oprofile/cell' into oprofile/oprofile-for-tip

 arch/Kconfig                              |    2 +
 arch/powerpc/include/asm/cell-pmu.h       |    2 +
 arch/powerpc/include/asm/oprofile_impl.h  |    6 +
 arch/powerpc/oprofile/cell/pr_util.h      |   11 +-
 arch/powerpc/oprofile/cell/spu_profiler.c |   56 ++-
 arch/powerpc/oprofile/common.c            |   22 +
 arch/powerpc/oprofile/op_model_cell.c     |  748 ++++++++++++++++++++++++-----
 arch/x86/oprofile/op_model_amd.c          |  224 ++++-----
 drivers/oprofile/buffer_sync.c            |  229 +++------
 drivers/oprofile/cpu_buffer.c             |  393 +++++++++------
 drivers/oprofile/cpu_buffer.h             |   72 +++-
 drivers/oprofile/event_buffer.c           |    4 +-
 drivers/oprofile/oprof.c                  |    4 +-
 drivers/oprofile/oprof.h                  |    8 +-
 drivers/oprofile/oprofile_files.c         |   24 +-
 include/linux/oprofile.h                  |   21 +-
 include/linux/ring_buffer.h               |    2 +
 kernel/trace/ring_buffer.c                |   44 ++-
 kernel/trace/trace.c                      |    4 +-
 19 files changed, 1271 insertions(+), 605 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

