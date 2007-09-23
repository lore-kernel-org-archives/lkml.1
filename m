Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbXIWKQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbXIWKQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 06:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbXIWKQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 06:16:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:50245 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbXIWKQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 06:16:03 -0400
Date: Sun, 23 Sep 2007 10:15:56 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Linux 2.6.20.20
Message-ID: <20070923101556.GA23231@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.6.20.20.

It includes a fix for CVE-2007-4573 which affects the x86_64 architecture
with a risk of local privilege escalation. All x86_64 users are encouraged
to upgrade. An old minor fix was also included to prevent users from cheating
on setrlimit(RLIMIT_CPU). This one was merged in 2.6.22-rc1.

Note to the 2.6.20.y users:
  The patch rate on 2.6.22.y has significantly dropped, so it is about
  time to give it a try. Those who have not tested it yet are strongly
  encouraged to prepare for a migration, as there will not be many more
  2.6.20.y releases.

I'll also be replying to this message with a copy of the patch between
2.6.20.19 and 2.6.20.20.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/patch-2.6.20.20.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.20.20

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.20.y.git

Willy

-------

 Makefile                     |    2 +-
 arch/x86_64/ia32/ia32entry.S |   18 +++++++++++++++---
 arch/x86_64/kernel/ptrace.c  |    4 ----
 kernel/sys.c                 |   19 ++++++++++---------
 4 files changed, 26 insertions(+), 17 deletions(-)

Summary of changes from 2.6.20.19 to 2.6.20.20
============================================

Andi Kleen (1):
      x86_64: Zero extend all registers after ptrace in 32bit entry path.

Tom Alsberg (1):
      CPU time limit patch / setrlimit(RLIMIT_CPU, 0) cheat fix

Willy Tarreau (1):
      Linux 2.6.20.20

