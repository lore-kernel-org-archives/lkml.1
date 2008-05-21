Return-Path: <linux-kernel-owner+w=401wt.eu-S933972AbYEUAtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972AbYEUAtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933660AbYEUAsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:48:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41612 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933485AbYEUAsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:48:23 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 2/6][uml] fix include order in sys-i386/registers.c
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Message-Id: <E1JycVC-00064Z-K3@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:48:22 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	We want sys/ptrace.h before any includes of linux/ptrace.h and
asm/user.h pulls the latter.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Jeff Dike <jdike@addtoit.com>
---
 arch/um/os-Linux/sys-i386/registers.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/um/os-Linux/sys-i386/registers.c b/arch/um/os-Linux/sys-i386/registers.c
index c6183e7..b487cbe 100644
--- a/arch/um/os-Linux/sys-i386/registers.c
+++ b/arch/um/os-Linux/sys-i386/registers.c
@@ -5,6 +5,7 @@
  */
 
 #include <errno.h>
+#include <sys/ptrace.h>
 #include <asm/user.h>
 #include "kern_constants.h"
 #include "longjmp.h"
-- 
1.5.3.GIT


