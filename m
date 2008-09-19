Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbYISSqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbYISSqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 14:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbYISSpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 14:45:50 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39415 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108AbYISSpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 14:45:49 -0400
Date: Fri, 19 Sep 2008 20:45:27 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Late avr32 fixes for 2.6.27
Message-ID: <20080919204527.2b50bded@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Sep 2008 18:45:17.0178 (UTC) FILETIME=[DC1105A0:01C91A87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git master

to receive the following fixes. Among other things, this makes the ext4
filesystem build and work on avr32 (neither of which it did before).

Haavard Skinnemoen (1):
      atstk1000: fix build breakage with BOARD_ATSTK100X_SW2_CUSTOM=y

Hans-Christian Egtvedt (2):
      avr32: add generic_find_next_le_bit bit function
      avr32: fix sys_sync_file_range() call convention

Manfred Spraul (1):
      avr32: nmi_enter() without nmi_exit()

Markus Heidelberg (1):
      avr32: add .gitignore files

 arch/avr32/boards/atstk1000/atstk1002.c |    2 +-
 arch/avr32/boot/images/.gitignore       |    4 ++++
 arch/avr32/kernel/.gitignore            |    1 +
 arch/avr32/kernel/avr32_ksyms.c         |    1 +
 arch/avr32/kernel/syscall-stubs.S       |    9 +++++++++
 arch/avr32/kernel/syscall_table.S       |    2 +-
 arch/avr32/kernel/traps.c               |    8 ++++----
 arch/avr32/lib/findbit.S                |   30 ++++++++++++++++++++++++++++++
 8 files changed, 51 insertions(+), 6 deletions(-)
 create mode 100644 arch/avr32/boot/images/.gitignore
 create mode 100644 arch/avr32/kernel/.gitignore
