Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbYHAP2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbYHAP2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYHAP2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:28:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:56470 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbYHAP2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:28:13 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [git pull] kgdb 2.6.27 fixes 
Date: Fri,  1 Aug 2008 10:27:51 -0500
Message-Id: <1217604474-24239-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.5.1
X-OriginalArrivalTime: 01 Aug 2008 15:27:53.0729 (UTC) FILETIME=[2A945F10:01C8F3EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the kgdb git tree fixes for 2.6.27.

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus


Summary: 

Several regressions have been fixed for which there was no automated test.
 - There is no requirement for CONFIG_FRAME_POINTER.
 - When using CONFIG_DEBUG_RODATA kgdb silently failed to set
   breakpoints instead of reporting an error.
 - The ability to query for the thread list from the debugger
   would silently hang the kernel.

---

Jason Wessel (3):
      kgdb: remove the requirement for CONFIG_FRAME_POINTER
      kgdb: fix kgdb_validate_break_address to perform a mem write
      kgdb: fix gdb serial thread queries

 Documentation/DocBook/kgdb.tmpl |   18 +++++++
 kernel/kgdb.c                   |   94 ++++++++++++++++++++++++++++----------
 lib/Kconfig.kgdb                |   11 +++--
 nus, please pull kgdb the kgdb git tree.
3 files changed, 94 insertions(+), 29 deletions(-)
