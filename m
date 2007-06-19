Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbXFSJXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbXFSJXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 05:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXFSJXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 05:23:24 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:55421 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbXFSJXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 05:23:22 -0400
Date: Tue, 19 Jun 2007 18:21:48 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh fixes
Message-ID: <20070619092148.GC23697@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Kaz Kojima (1):
      sh: Fix restartable syscall arg5 clobbering.

Paul Mundt (2):
      sh: oops_enter()/oops_exit() in die().
      sh: Handle -ERESTART_RESTARTBLOCK for restartable syscalls.

 arch/sh/kernel/signal.c |    9 ++++++---
 arch/sh/kernel/traps.c  |    3 +++
 2 files changed, 9 insertions(+), 3 deletions(-)
