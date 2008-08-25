Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbYHYCX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbYHYCX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 22:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYHYCX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 22:23:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59041 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbYHYCX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 22:23:26 -0400
Message-ID: <48B2175E.3070407@cn.fujitsu.com>
Date: Mon, 25 Aug 2008 10:22:22 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] devcgroup: remove unused variable
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 security/device_cgroup.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 9c625f6..d5c15a7 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -355,7 +355,7 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 	struct dev_cgroup *cur_devcgroup;
 	const char *b;
 	char *endp;
-	int retval = 0, count;
+	int count;
 	struct dev_whitelist_item wh;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -432,7 +432,6 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 	}
 
 handle:
-	retval = 0;
 	switch (filetype) {
 	case DEVCG_ALLOW:
 		if (!parent_has_perm(devcgroup, &wh))
-- 
1.5.4.rc3


