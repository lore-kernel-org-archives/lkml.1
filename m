Return-Path: <linux-kernel-owner+w=401wt.eu-S932152AbZKFAmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbZKFAmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932129AbZKFAmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:42:47 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:43434 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759256AbZKFAmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:42:12 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-arch@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 10/11] sysctl: Remove the cond_syscall entry for sys32_sysctl
Date: Thu,  5 Nov 2009 16:41:53 -0800
Message-Id: <1257468114-6823-10-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1tyx8trik.fsf@fess.ebiederm.org>
References: <m1tyx8trik.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that all architechtures are use compat_sys_sysctl and sys32_sysctl
does not exist there is not point in retaining a cond_syscall
entry for it.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/sys_ni.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index e06d0b8..de5bf14 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -139,7 +139,6 @@ cond_syscall(sys_pciconfig_read);
 cond_syscall(sys_pciconfig_write);
 cond_syscall(sys_pciconfig_iobase);
 cond_syscall(sys32_ipc);
-cond_syscall(sys32_sysctl);
 cond_syscall(ppc_rtas);
 cond_syscall(sys_spu_run);
 cond_syscall(sys_spu_create);
-- 
1.6.5.2.143.g8cc62

