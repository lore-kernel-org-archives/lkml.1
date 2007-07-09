Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbXGIQbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbXGIQbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758198AbXGIQXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447AbXGIQXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:52 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] show default protocol
Date: Mon,  9 Jul 2007 17:02:29 +0100
Message-Id: <1183997036270-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1183997034982-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
 <11839970282009-git-send-email-swhiteho@redhat.com>
 <11839970302426-git-send-email-swhiteho@redhat.com>
 <11839970324005-git-send-email-swhiteho@redhat.com>
 <1183997034982-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

Display the initial value of the "protocol" config value in configfs.
The default value has always been 0 in the past anyway, so it's always
appeared to be correct.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 1b59fa5..5069b2c 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -433,6 +433,7 @@ static struct config_group *make_cluster(struct config_group *g,
 	cl->cl_toss_secs = dlm_config.ci_toss_secs;
 	cl->cl_scan_secs = dlm_config.ci_scan_secs;
 	cl->cl_log_debug = dlm_config.ci_log_debug;
+	cl->cl_protocol = dlm_config.ci_protocol;
 	cl->cl_timewarn_cs = dlm_config.ci_timewarn_cs;
 
 	space_list = &sps->ss_group;
-- 
1.5.1.2

