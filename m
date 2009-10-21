Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbZJUAtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbZJUAtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 20:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZJUAtC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 20:49:02 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36731 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbZJUAtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 20:49:01 -0400
Date: Wed, 21 Oct 2009 09:47:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.32-rc6
Message-ID: <20091021004749.GA17730@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.32

Which contains:

Magnus Damm (1):
      sh: disabled cache handling fix.

Paul Mundt (1):
      sh: Kill off stray HAVE_FTRACE_SYSCALLS reference.

Thomas Gleixner (1):
      sh: Remove BKL from landisk gio.

Valentin Sitdikov (1):
      sh: Fix up single page flushing to use PAGE_SIZE.

 arch/sh/Kconfig                   |    1 -
 arch/sh/boards/mach-landisk/gio.c |   10 ++++------
 arch/sh/mm/cache-sh4.c            |   22 ++++++++++------------
 arch/sh/mm/cache.c                |   10 ++++++++++
 4 files changed, 24 insertions(+), 19 deletions(-)
