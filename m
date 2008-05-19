Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbYESKss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbYESKss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 06:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbYESKsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 06:48:41 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:36267 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755609AbYESKsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 06:48:40 -0400
Date: Mon, 19 May 2008 19:47:11 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.26-rc3
Message-ID: <20080519104711.GA11875@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Harvey Harrison (1):
      sh: use the common ascii hex helpers

Hideo Saito (2):
      sh: Fix up optimized SH-4 memcpy on big endian.
      sh: Fix up thread info pointer in syscall_badsys resume path.

Paul Mundt (4):
      sh: display boot params by default on entry.
      sh: disable initrd defaults in .empty_zero_page.
      sh: Make is_valid_bugaddr() more intelligent on nommu.
      sh: Fix up restorer in debug_trap exception return path.

Yoshihiro Shimoda (1):
      sh: fix sh7785 master clock value

 arch/sh/kernel/cpu/sh4a/clock-sh7785.c |    2 +-
 arch/sh/kernel/entry-common.S          |   12 ++++++------
 arch/sh/kernel/head_32.S               |    4 ++--
 arch/sh/kernel/kgdb_stub.c             |   11 +++++------
 arch/sh/kernel/setup.c                 |   11 +++++++++++
 arch/sh/kernel/traps.c                 |   10 +++++++++-
 arch/sh/lib/memcpy-sh4.S               |   22 +++++++++++-----------
 drivers/serial/sh-sci.c                |    8 ++++----
 include/asm-sh/kgdb.h                  |   14 --------------
 9 files changed, 49 insertions(+), 45 deletions(-)
