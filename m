Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbZBKPXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbZBKPXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbZBKPXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:23:24 -0500
Received: from mailhost.igel.co.jp ([219.106.231.130]:41197 "EHLO
	mailhost.igel.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZBKPXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:23:24 -0500
X-Greylist: delayed 1298 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Feb 2009 10:23:23 EST
From: Katsuya Matsubara <matsu@igel.co.jp>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mundt <lethal@linux-sh.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Katsuya Matsubara <matsu@igel.co.jp>
Subject: [PATCH RT 0/4] sh arch support for 2.6.28-rt
Date: Thu, 12 Feb 2009 00:01:39 +0900
Message-Id: <1234364503-857-1-git-send-email-matsu@igel.co.jp>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches apply preempt-rt treatments into sh specific code.
64 bit support is not included because I have no sh64 board.
These are based on the 2.6.28-rt git.

I made sure that these work on renesas rts7751r2dplus.

-- Katsuya Matsubara / matsu@igel.co.jp

---

Katsuya Matsubara (4):
  sh: use __preempt_enable_no_resched in cpu_idle()
  sh: enable interrupts in signal handling
  sh: decouple the pagefault-disabled logic
  convert-locks-list: add sh specific spin locks

 arch/sh/kernel/process_32.c |    2 +-
 arch/sh/kernel/signal_32.c  |    7 +++++++
 arch/sh/mm/fault_32.c       |    2 +-
 scripts/convert-locks-list  |   12 ++++++++++++
 4 files changed, 21 insertions(+), 2 deletions(-)

