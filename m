Return-Path: <linux-kernel-owner+w=401wt.eu-S1762901AbYEHK7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762901AbYEHK7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 06:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYEHK7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 06:59:13 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:48322 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbYEHK7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 06:59:12 -0400
Date: Thu, 8 May 2008 16:29:03 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: menage@google.com
Cc: nikhil.john@yahoo.com, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix cgroups documentation
Message-ID: <20080508105903.GA3870@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just correcting the cgroups documentation to reflect the correct file names.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

Index: linux-2.6/Documentation/cgroups.txt
===================================================================
--- linux-2.6.orig/Documentation/cgroups.txt	2008-04-30 14:42:05.000000000 +0530
+++ linux-2.6/Documentation/cgroups.txt	2008-05-08 16:26:58.000000000 +0530
@@ -310,8 +310,8 @@ and then start a subshell 'sh' in that c
   cd /dev/cgroup
   mkdir Charlie
   cd Charlie
-  /bin/echo 2-3 > cpus
-  /bin/echo 1 > mems
+  /bin/echo 2-3 > cpuset.cpus
+  /bin/echo 1 > cpuset.mems
   /bin/echo $$ > tasks
   sh
   # The subshell 'sh' is now running in cgroup Charlie

-- 
regards,
Dhaval
