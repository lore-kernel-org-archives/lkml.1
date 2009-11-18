Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbZKRQob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbZKRQob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757865AbZKRQo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:44:29 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41719 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631AbZKRQoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:44:17 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 18 Nov 2009 08:44:12 -0800
Message-Id: <1258562654-31370-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1d43fbx8i.fsf@fess.ebiederm.org>
References: <m1d43fbx8i.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 1/3] sysctl: kill dead ctl_handler definitions.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

When removing the sysctl strategy routines I overlooked their definitions
in sysctl.h.    So remove those unnecessary definitions now.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/sysctl.h |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 4e40442..b4f6adc 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -972,10 +972,6 @@ extern int sysctl_perm(struct ctl_table_root *root,
 
 typedef struct ctl_table ctl_table;
 
-typedef int ctl_handler (struct ctl_table *table,
-			 void __user *oldval, size_t __user *oldlenp,
-			 void __user *newval, size_t newlen);
-
 typedef int proc_handler (struct ctl_table *ctl, int write,
 			  void __user *buffer, size_t *lenp, loff_t *ppos);
 
@@ -996,13 +992,6 @@ extern int proc_doulongvec_minmax(struct ctl_table *, int,
 extern int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int,
 				      void __user *, size_t *, loff_t *);
 
-extern ctl_handler sysctl_data;
-extern ctl_handler sysctl_string;
-extern ctl_handler sysctl_intvec;
-extern ctl_handler sysctl_jiffies;
-extern ctl_handler sysctl_ms_jiffies;
-
-
 /*
  * Register a set of sysctl names by calling register_sysctl_table
  * with an initialised array of struct ctl_table's.  An entry with 
-- 
1.6.5.2.143.g8cc62

