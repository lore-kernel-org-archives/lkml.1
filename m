Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbYFCLex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbYFCLex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 07:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYFCLep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 07:34:45 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:18850 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752942AbYFCLeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 07:34:44 -0400
Date: Tue, 3 Jun 2008 20:32:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.26-rc5
Message-ID: <20080603113249.GA15541@linux-sh.org>
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

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.26.git

Which contains:

Adrian Bunk (1):
      sh/kernel/cpu/irq/intc-sh5.c build fix

Harvey Harrison (1):
      sh: module.c use kernel unaligned helpers

Paul Mundt (4):
      sh: fix miscompilation of ip_fast_csum with gcc >= 4.3
      sh: Disable 4KSTACKS on nommu.
      sh: Update SE7206 defconfig.
      sh: Add defconfig for RSK7203.

 arch/sh/Kconfig.debug             |    2 +-
 arch/sh/configs/rsk7203_defconfig |  841 +++++++++++++++++++++++++++++++++++++
 arch/sh/configs/se7206_defconfig  |  475 ++++++++++++++-------
 arch/sh/kernel/cpu/irq/intc-sh5.c |    1 +
 arch/sh/kernel/module.c           |   39 +--
 include/asm-sh/checksum_32.h      |    2 +-
 6 files changed, 1164 insertions(+), 196 deletions(-)
 create mode 100644 arch/sh/configs/rsk7203_defconfig
