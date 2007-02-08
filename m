Return-Path: <linux-kernel-owner+w=401wt.eu-S1423346AbXBHWx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423346AbXBHWx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 17:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423323AbXBHWx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 17:53:59 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48018 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423346AbXBHWx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 17:53:58 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       James Morris <jmorris@namei.org>
Subject: [PATCH 1/5] sysctl:  Remove declaration of nonexistent sysctl_init()
References: <200701280106.l0S16CG3019873@shell0.pdx.osdl.net>
	<20070127172410.2b041952.akpm@osdl.org>
	<1169972718.17469.164.camel@localhost.localdomain>
	<20070128003549.2ca38dc8.akpm@osdl.org>
	<20070128093358.GA2071@elte.hu> <20070128095712.GA6485@elte.hu>
	<20070128100627.GA8416@elte.hu>
	<20070128104548.a835d859.akpm@osdl.org>
	<m1r6tfq7nv.fsf_-_@ebiederm.dsl.xmission.com>
	<1170075866.8720.15.camel@moss-spartans.epoch.ncsc.mil>
	<m17iuvrnpk.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b5jrngt.fsf_-_@ebiederm.dsl.xmission.com>
	<1170872654.11912.87.camel@moss-spartans.epoch.ncsc.mil>
	<1170882738.11912.144.camel@moss-spartans.epoch.ncsc.mil>
	<m17iutmmwh.fsf@ebiederm.dsl.xmission.com>
	<1170946871.11912.250.camel@moss-spartans.epoch.ncsc.mil>
	<m14ppwa64j.fsf@ebiederm.dsl.xmission.com>
	<1170958404.11912.313.camel@moss-spartans.epoch.ncsc.mil>
	<m1mz3o8fbf.fsf@ebiederm.dsl.xmission.com>
	<m1abzo8dr0.fsf_-_@ebiederm.dsl.xmission.com>
Date: Thu, 08 Feb 2007 15:53:08 -0700
In-Reply-To: <m1abzo8dr0.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Thu, 08 Feb 2007 15:51:15 -0700")
Message-ID: <m164ac8dnv.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/sysctl.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 538f6d2..b5c2b3e 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -929,8 +929,6 @@ extern struct ctl_table_header *sysctl_head_next(struct ctl_table_header *prev);
 extern void sysctl_head_finish(struct ctl_table_header *prev);
 extern int sysctl_perm(struct ctl_table *table, int op);
 
-extern void sysctl_init(void);
-
 typedef struct ctl_table ctl_table;
 
 typedef int ctl_handler (ctl_table *table, int __user *name, int nlen,
-- 
1.4.4.1.g278f

