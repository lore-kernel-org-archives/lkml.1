Return-Path: <linux-kernel-owner+w=401wt.eu-S1761770AbZLPIJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761770AbZLPIJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761761AbZLPIJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:09:17 -0500
Received: from mail.perches.com ([173.55.12.10]:1193 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbZLPIJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:09:15 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/14] kernel.h cleanups
Date: Wed, 16 Dec 2009 00:08:59 -0800
Message-Id: <cover.1260949674.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one seems to like taking patches for kernel.h
so I'm sending these to Linus and seeing what happens.

kernel.h has become a chaotic jumble collected over time.
Collect the functions and #defines together in logical groups.
Do some checkpatch neatening and make it more style conformant.

Compiled x86 allnoconfig, allyesconfig, defconfig

Joe Perches (14):
  kernel.h: Consolidate console and logging functions and defines
  kernel.h: Checkpatch cleaning
  kernel.h: ARRAY_SIZE neatening
  kernel.h: Add argument names to strtoXX, Xscanf prototypes
  kernel.h: printk neatening
  drivers/firmware/iscsi_ibft.c: Use %pI4 to print netmask
  kernel.h: Move NIPQUAD and NIPQUAD_FMT to in.h
  kernel.h: Group math and limits functions, indent function args
  kernel.h: Don't use NORET_AND just use noreturn, instead
  kernel.h: Remove ATTRIB_NORET, use __attribute__((noreturn))
  kernel.h: Remove uses of NORET_TYPE
  kernel.h: Add pr_<level>_once
  kernel.h: Kernel address utility aggregation and other neatening
  kernel/exit.c and kernel/panic.c: Remove unused NORET_TYPE

 drivers/firmware/iscsi_ibft.c |    8 +-
 include/linux/in.h            |   11 +
 include/linux/kernel.h        |  742 +++++++++++++++++++++++------------------
 kernel/exit.c                 |    4 +-
 kernel/panic.c                |    2 +-
 5 files changed, 437 insertions(+), 330 deletions(-)

