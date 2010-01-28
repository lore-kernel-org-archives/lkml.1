Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730Ab0A1XF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab0A1XF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570Ab0A1XFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:05:25 -0500
Received: from mail.windriver.com ([147.11.1.11]:46100 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab0A1XFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:05:25 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [GIT PULL]  kgdb regression fixes for 2.6.33
Date: Thu, 28 Jan 2010 17:04:41 -0600
Message-Id: <1264719883-7285-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 28 Jan 2010 23:04:50.0374 (UTC) FILETIME=[4B4E2660:01CAA06E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the kgdb git tree fixes for 2.6.33-rc5

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Summary:
  
  * Fix the kgdb regression in functionality caused by the new hw
    breakpoint API changes in 2.6.33.

This leaves us with some cleanup in 2.6.34, but all the previous
functionality works again.  In fact you can use hw breakpoints in user
space and the kernel at the same time now that the API is shared,
which is something that never previously worked.

Thanks,
Jason.

--
The following changes since commit be8cde8b24c9dca1e54598690115eee5b1476519:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../jejb/scsi-rc-fixes-2.6

--
Jason Wessel (2):
      x86,hw_breakpoint,kgdb: kgdb to use hw_breakpoint API
      perf,hw_breakpoint,kgdb: No mutex taken for kernel debugger

 arch/x86/kernel/kgdb.c        |  222 ++++++++++++++++++++++++++++++-----------
 include/linux/hw_breakpoint.h |    2 +
 kernel/hw_breakpoint.c        |   52 ++++++++--
 kernel/kgdb.c                 |    3 +
 4 files changed, 212 insertions(+), 67 deletions(-)
