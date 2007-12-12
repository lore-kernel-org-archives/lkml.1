Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbXLLCi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbXLLCi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 21:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbXLLCis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 21:38:48 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:34783 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751389AbXLLCir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 21:38:47 -0500
Date: Wed, 12 Dec 2007 08:08:36 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: [PATCH] Add Documentation for FAIR_USER_SCHED sysfs files
Message-ID: <20071212023836.GB1486@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds documentation about /sys/kernel/uids/<uid>/cpu_share
to Documentation/ABI.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

---
 Documentation/ABI/testing/sysfs-kernel-uids |   10 ++++++++++
 1 files changed, 10 insertions(+)

Index: current/Documentation/ABI/testing/sysfs-kernel-uids
===================================================================
--- /dev/null
+++ current/Documentation/ABI/testing/sysfs-kernel-uids
@@ -0,0 +1,10 @@
+What:		/sys/kernel/uids/<uid>/cpu_shares
+Date:		December 2007
+Contact:	Dhaval Giani <dhaval@linux.vnet.ibm.com>
+		Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
+Description:
+		The /sys/kernel/uids/<uid>/cpu_shares tunable is used
+		to set the cpu bandwidth a user is allowed. This is a
+		propotional value. What that means is that if there
+		are two users logged in, each with shares 1024, they
+		will get equal CPU bandwidth.
-- 
regards,
Dhaval
