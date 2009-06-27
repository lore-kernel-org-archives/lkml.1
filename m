Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbZF0OIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbZF0OIa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 10:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZF0OIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 10:08:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58026 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZF0OIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 10:08:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/6] score cleanups
Date: Sat, 27 Jun 2009 16:08:12 +0200
Message-Id: <cover.1246111364.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
X-Provags-ID: V01U2FsdGVkX19JB9FEAXSdWTVejvpTA/qzDOq/bdhou12uOg9
 kSmuLnQvs5FBV5ChU0pE9IZGx4yRPm3wOoFoDh/YiwzxNdOiWv
 3Zp6UHao/wzmnO1VlG8zQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liqin,

I've gone over your code a bit with sparse and some clues,
cleaning up some areas that stuck out.

Please check that these make sense.

	Arnd <><

Arnd Bergmann (6):
  score: add missing #includes
  score: add address space annotations
  score: fix function prototypes
  score: cleanups: dead code, 0 as pointer, shadowed variables
  score: make irq.h definitions local
  score: clean up mm/init.c

 arch/score/include/asm/irq.h      |   10 ---------
 arch/score/include/asm/uaccess.h  |    4 +-
 arch/score/include/asm/ucontext.h |    1 +
 arch/score/kernel/irq.c           |   33 ++++++++++++++++++++++---------
 arch/score/kernel/module.c        |   13 ++++++-----
 arch/score/kernel/process.c       |    3 ++
 arch/score/kernel/ptrace.c        |    7 +++--
 arch/score/kernel/signal.c        |   38 +++++++++++++++++++++---------------
 arch/score/kernel/sys_score.c     |   28 +++++++++-----------------
 arch/score/kernel/time.c          |    2 +-
 arch/score/mm/init.c              |   34 +++++++++-----------------------
 11 files changed, 83 insertions(+), 90 deletions(-)
 create mode 100644 arch/score/include/asm/ucontext.h

