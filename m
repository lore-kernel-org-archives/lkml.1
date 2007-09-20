Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbXITHJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbXITHJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbXITHFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:05:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44419 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbXITHF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:05:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=psxg10sDO8w8G/7zJnSSTiPuYaR/YpZZf7qCwd1z78blJYhfFJlIdKvuvbK+aAzYfwU7j8wN7QRXmI8vam356yPJn19M97S+jVSmidXBBjybWeUzwLw4htft90oWsM9kIkzxaEQlQS3D27/ZWLeD4GqaXQqNhGb44m04UNBo7xI=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 06/15] sysfs: reposition sysfs_dirent->s_mode.
In-Reply-To: <11902719091692-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:05:10 +0900
Message-Id: <11902719102073-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move s_mode downward such that it's side-by-side with s_iattr which is
used for the same thing.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/sysfs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 63adbec..6cf61c8 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -39,8 +39,8 @@ struct sysfs_dirent {
 	}			s_elem;
 
 	unsigned int		s_flags;
-	umode_t			s_mode;
 	ino_t			s_ino;
+	umode_t			s_mode;
 	struct iattr		*s_iattr;
 	atomic_t		s_event;
 };
-- 
1.5.0.3


