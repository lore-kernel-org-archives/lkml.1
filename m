Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbZKHMWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbZKHMWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbZKHMWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:22:12 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59075 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbZKHMWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:12 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH 01/23] sysctl: Remove the unused frv sysctl unumbers
Date: Sun,  8 Nov 2009 04:21:48 -0800
Message-Id: <1257682930-31401-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m14op5jjo4.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

The frv sysctl tables can only be used from proc so kill
the sysctl numbers.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/frv/kernel/pm.c     |    2 +-
 arch/frv/kernel/sysctl.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/frv/kernel/pm.c b/arch/frv/kernel/pm.c
index 0d4d3e3..17e2e3f 100644
--- a/arch/frv/kernel/pm.c
+++ b/arch/frv/kernel/pm.c
@@ -393,7 +393,7 @@ static int cm_sysctl(ctl_table *table,
 static struct ctl_table pm_table[] =
 {
 	{
-		.ctl_name	= CTL_PM_SUSPEND,
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "suspend",
 		.data		= NULL,
 		.maxlen		= 0,
diff --git a/arch/frv/kernel/sysctl.c b/arch/frv/kernel/sysctl.c
index 3e9d7e0..139628a 100644
--- a/arch/frv/kernel/sysctl.c
+++ b/arch/frv/kernel/sysctl.c
@@ -176,7 +176,7 @@ static int procctl_frv_pin_cxnr(ctl_table *table, int write, struct file *filp,
 static struct ctl_table frv_table[] =
 {
 	{
-		.ctl_name 	= 1,
+		.ctl_name 	= CTL_UNNUMBERD,
 		.procname 	= "cache-mode",
 		.data		= NULL,
 		.maxlen		= 0,
@@ -185,7 +185,7 @@ static struct ctl_table frv_table[] =
 	},
 #ifdef CONFIG_MMU
 	{
-		.ctl_name	= 2,
+		.ctl_name	= CTL_UNNUMBERD,
 		.procname	= "pin-cxnr",
 		.data		= NULL,
 		.maxlen		= 0,
@@ -203,7 +203,7 @@ static struct ctl_table frv_table[] =
 static struct ctl_table frv_dir_table[] =
 {
 	{
-		.ctl_name	= CTL_FRV,
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "frv",
 		.mode 		= 0555,
 		.child		= frv_table
-- 
1.6.5.2.143.g8cc62

