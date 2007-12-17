Return-Path: <linux-kernel-owner+w=401wt.eu-S935542AbXLQUeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935542AbXLQUeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933236AbXLQUeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:34:14 -0500
Received: from mx1.suse.de ([195.135.220.2]:60856 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932377AbXLQUeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 15:34:12 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/7] Add Documentation for FAIR_USER_SCHED sysfs files
Date: Mon, 17 Dec 2007 12:33:20 -0800
Message-Id: <1197923603-6752-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <20071217185654.GC4330@kroah.com>
References: <20071217185654.GC4330@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dhaval Giani <dhaval@linux.vnet.ibm.com>

This patch adds documentation about /sys/kernel/uids/<uid>/cpu_share
to Documentation/ABI.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/ABI/testing/sysfs-kernel-uids |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-uids

diff --git a/Documentation/ABI/testing/sysfs-kernel-uids b/Documentation/ABI/testing/sysfs-kernel-uids
new file mode 100644
index 0000000..648d65d
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-uids
@@ -0,0 +1,14 @@
+What:		/sys/kernel/uids/<uid>/cpu_shares
+Date:		December 2007
+Contact:	Dhaval Giani <dhaval@linux.vnet.ibm.com>
+		Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
+Description:
+		The /sys/kernel/uids/<uid>/cpu_shares tunable is used
+		to set the cpu bandwidth a user is allowed. This is a
+		propotional value. What that means is that if there
+		are two users logged in, each with an equal number of
+		shares, then they will get equal CPU bandwidth. Another
+		example would be, if User A has shares = 1024 and user
+		B has shares = 2048, User B will get twice the CPU
+		bandwidth user A will. For more details refer
+		Documentation/sched-design-CFS.txt
-- 
1.5.3.7

