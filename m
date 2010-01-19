Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818Ab0ASIFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0ASIFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949Ab0ASIFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:05:24 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:45673 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab0ASIFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:05:21 -0500
Date: Tue, 19 Jan 2010 17:05:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.33-rc5, part 2.
Message-ID: <20100119080509.GD16013@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few more minor changes, primarily addressing the recvmmsg/accept4 mess.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.33

Which contains:

Kuninori Morimoto (1):
      sh: ms7724: Correct sh-eth EEPROM polling timeout.

Paul Mundt (2):
      sh: unwire sys_recvmmsg.
      sh64: wire up sys_accept4.

 arch/sh/boards/mach-se/7724/setup.c |    2 +-
 arch/sh/include/asm/unistd_32.h     |    5 +++--
 arch/sh/include/asm/unistd_64.h     |    3 ++-
 arch/sh/kernel/syscalls_32.S        |    1 -
 arch/sh/kernel/syscalls_64.S        |    1 +
 5 files changed, 7 insertions(+), 5 deletions(-)
