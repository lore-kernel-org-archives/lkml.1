Return-Path: <linux-kernel-owner+w=401wt.eu-S1751298AbXBMLyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbXBMLyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 06:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbXBMLyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 06:54:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:1982 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbXBMLyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 06:54:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent:from;
        b=rOn7OXvaZF+WnxWntLwR3/EPrluoT80zShvuzrrwk4HRJDkKWZIsioenJU3/grv0coVTDp0aCrFy+NzWoSeO+Y7Hyg3O0zsuYFSYkTpgi2DBzYZyvUrXNEJISRaQjOiVylOYJoaU2JyvxfAwIC7wL5PG7p16LgO5hrqEGmyW/OU=
Date: Tue, 13 Feb 2007 12:54:31 +0100
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ecryptfs: fix forgotten format specifier
Message-ID: <20070213115431.GA3023@unknown-00-0d-60-79-ca-00.lan>
Mail-Followup-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
From: Thomas Hisch <t.hisch@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

add format specifier %d for uid in ecryptfs_printk

Signed-off-by: Thomas Hisch <t.hisch@gmail.com>
---
 fs/ecryptfs/messaging.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index 47d7e7b..1674d33 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -169,7 +169,8 @@ int ecryptfs_process_helo(unsigned int transport, uid_t uid, pid_t pid)
 	if (!new_id) {
 		rc = -ENOMEM;
 		ecryptfs_printk(KERN_ERR, "Failed to allocate memory; unable "
-				"to register daemon [%d] for user\n", pid, uid);
+				"to register daemon [%d] for user [%d]\n", 
+				pid, uid);
 		goto unlock;
 	}
 	if (!ecryptfs_find_daemon_id(uid, &old_id)) {
-- 
1.5.0.rc3.22.g5057

-- 
Thomas Hisch
e0625874@stud.tuwien.ac.at
