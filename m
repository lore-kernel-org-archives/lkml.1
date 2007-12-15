Return-Path: <linux-kernel-owner+w=401wt.eu-S1760682AbXLOA2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760682AbXLOA2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 19:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbXLOA2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 19:28:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:42992 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbXLOA2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 19:28:16 -0500
Subject: patch add-documentation-for-fair_user_sched-sysfs-files.patch added to gregkh-2.6 tree
To: dhaval@linux.vnet.ibm.com, akpm@linux-foundation.org, balbir@in.ibm.com,
       gregkh@suse.de, linux-kernel@vger.kernel.org, mingo@elte.hu,
       vatsa@linux.vnet.ibm.com
From: <gregkh@suse.de>
Date: Fri, 14 Dec 2007 16:11:10 -0800
In-Reply-To: <20071212054859.GC1486@linux.vnet.ibm.com>
Message-ID: <1197677470@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: Add Documentation for FAIR_USER_SCHED sysfs files

to my gregkh-2.6 tree.  Its filename is

     add-documentation-for-fair_user_sched-sysfs-files.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From dhaval@linux.vnet.ibm.com Tue Dec 11 21:51:17 2007
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Date: Wed, 12 Dec 2007 11:18:59 +0530
Subject: Add Documentation for FAIR_USER_SCHED sysfs files
To: Greg KH <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Balbir Singh <balbir@in.ibm.com>
Message-ID: <20071212054859.GC1486@linux.vnet.ibm.com>
Content-Disposition: inline

This patch adds documentation about /sys/kernel/uids/<uid>/cpu_share
to Documentation/ABI.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/ABI/testing/sysfs-kernel-uids |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

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


Patches currently in gregkh-2.6 which might be from dhaval@linux.vnet.ibm.com are

driver/struct-user_info-sysfs.patch
driver/add-documentation-for-fair_user_sched-sysfs-files.patch
