Return-Path: <linux-kernel-owner+w=401wt.eu-S933924AbYBHSSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924AbYBHSSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757798AbYBHSSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:18:15 -0500
Received: from kbspmxp4.starhub.net.sg ([203.116.61.214]:61065 "EHLO
	kbspmxp1.starhub.net.sg" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759317AbYBHSSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:18:14 -0500
X-Greylist: delayed 11893 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2008 13:18:13 EST
Date: Fri, 08 Feb 2008 22:59:50 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
Subject: [PATCH] proc: Add RLIMIT_RTTIME to /proc/<pid>/limits
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Reply-to: Eugene Teo <eugeneteo@kernel.sg>
Message-id: <20080208145950.GA3910@kernel.sg>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RLIMIT_RTTIME was introduced to allow the user to set a runtime timeout on
real-time tasks: http://lkml.org/lkml/2007/12/18/218. This patch updates
/proc/<pid>/limits with the new rlimit.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 fs/proc/base.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index c59852b..dcf7be8 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -412,6 +412,7 @@ static const struct limit_names lnames[RLIM_NLIMITS] = {
 	[RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes"},
 	[RLIMIT_NICE] = {"Max nice priority", NULL},
 	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
+	[RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
 };
 
 /* Display limits for a process */
-- 

