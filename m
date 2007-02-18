Return-Path: <linux-kernel-owner+w=401wt.eu-S1751157AbXBREB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157AbXBREB3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 23:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbXBREB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 23:01:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54524 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbXBREB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 23:01:28 -0500
Date: Sun, 18 Feb 2007 04:01:27 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] audit patches
Message-ID: <20070218040127.GA5422@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Misc audit patches (resend again...); the most intrusive one is AUDIT_FD_PAIR,
allowing to log descriptor numbers from syscalls that do not return them in
usual way (i.e. pipe() and socketpair()).  It took some massage of
the failure exits in sys_socketpair(); the rest is absolutely trivial.
Please, pull from
git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b37

Al Viro (1):
      AUDIT_FD_PAIR

Steve Grubb (2):
      minor update to rule add/delete messages (ver 2)
      audit config lockdown

 fs/pipe.c             |    7 ++
 include/linux/audit.h |    9 ++
 kernel/audit.c        |  216 +++++++++++++++++++++++++++++++++++-------------
 kernel/auditfilter.c  |    9 +-
 kernel/auditsc.c      |   40 +++++++++
 net/socket.c          |   52 +++++++++---
 6 files changed, 257 insertions(+), 76 deletions(-)
