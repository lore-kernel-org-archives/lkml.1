Return-Path: <linux-kernel-owner+w=401wt.eu-S1751691AbZGOCU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbZGOCU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 22:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZGOCU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 22:20:57 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60149 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbZGOCU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 22:20:56 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Wed, 15 Jul 2009 07:50:41 +0530
Message-Id: <20090715022038.4374.74212.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH 05/06] Fix compilation warning for arch/x86/kernel/apm_32.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following fix is inspired by David Howells fix few days back:
http://lkml.org/lkml/2009/7/9/109,

Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>,
---

--- a/arch/x86/kernel/apm_32.c	2009-06-15 07:50:51.000000000 +0530
+++ b/arch/x86/kernel/apm_32.c	2009-07-15 06:43:59.000000000 +0530
@@ -811,7 +811,7 @@ static int apm_do_idle(void)
 	u8 ret = 0;
 	int idled = 0;
 	int polling;
-	int err;
+	int uninitialized_var(err);
 
 	polling = !!(current_thread_info()->status & TS_POLLING);
 	if (polling) {

---
Regards--
Subrata

