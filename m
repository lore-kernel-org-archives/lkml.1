Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbZKHMYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbZKHMYt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbZKHMYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:24:44 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59099 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbZKHMWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:40 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 19/23] sysctl powerpc: Remove dead binary sysctl support
Date: Sun,  8 Nov 2009 04:22:06 -0800
Message-Id: <1257682930-31401-19-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m14op5jjo4.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that sys_sysctl is a generic wrapper around /proc/sys  .ctl_name
and .strategy members of sysctl tables are dead code.  Remove them.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/powerpc/kernel/idle.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 88d9c1d..cece9e2 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -110,7 +110,6 @@ int powersave_nap;
  */
 static ctl_table powersave_nap_ctl_table[]={
 	{
-		.ctl_name	= KERN_PPC_POWERSAVE_NAP,
 		.procname	= "powersave-nap",
 		.data		= &powersave_nap,
 		.maxlen		= sizeof(int),
@@ -121,7 +120,6 @@ static ctl_table powersave_nap_ctl_table[]={
 };
 static ctl_table powersave_nap_sysctl_root[] = {
 	{
-		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
 		.mode		= 0555,
 		.child		= powersave_nap_ctl_table,
-- 
1.6.5.2.143.g8cc62

