Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbYGGQvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbYGGQvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbYGGQt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:49:59 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:20574
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753835AbYGGQt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:49:58 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 12:49:54 EDT
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: SELinux patches for 2.6.26
Date: Tue,  8 Jul 2008 01:42:02 +0900
Message-Id: <1215448942-17581-1-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please review these SELinux patches for the 2.6.26 kernel.

 fs/proc/base.c                      |    9 
 fs/proc/task_mmu.c                  |    6 
 fs/proc/task_nommu.c                |    2 
 include/linux/ptrace.h              |    8 
 include/linux/security.h            |   16 -
 kernel/ptrace.c                     |   15 -
 security/commoncap.c                |    3 
 security/dummy.c                    |    3 
 security/security.c                 |   11 
 security/selinux/hooks.c            |  156 +++++++-----
 security/selinux/include/audit.h    |    4 
 security/selinux/include/avc.h      |   15 -
 security/selinux/include/objsec.h   |    1 
 security/selinux/include/security.h |    7 
 security/selinux/netnode.c          |    1 
 security/selinux/netport.c          |    3 
 security/selinux/selinuxfs.c        |   15 -
 security/selinux/ss/avtab.c         |    2 
 security/selinux/ss/context.h       |   27 ++
 security/selinux/ss/mls.c           |   19 -
 security/selinux/ss/mls.h           |    3 
 security/selinux/ss/policydb.c      |   15 -
 security/selinux/ss/services.c      |  450 ++++++++++++++++++++++--------------
 security/selinux/ss/sidtab.c        |   76 ++----
 security/selinux/ss/sidtab.h        |    7 
 security/smack/smack_lsm.c          |    5 
 26 files changed, 518 insertions(+), 361 deletions(-)


