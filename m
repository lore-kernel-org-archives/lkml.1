Return-Path: <linux-kernel-owner+w=401wt.eu-S1762259AbZCXQJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259AbZCXQJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759541AbZCXQGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:06:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:41822 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762197AbZCXQGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:06:36 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/14] ide kill unused ide_cmd->special
Date: Wed, 25 Mar 2009 01:06:08 +0900
Message-Id: <1237910776-10983-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237910776-10983-1-git-send-email-tj@kernel.org>
References: <1237910776-10983-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 16:06:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: removal of unused field

No one uses ide_cmd->special anymore.  Kill it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/ide.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/ide.h b/include/linux/ide.h
index ccaf372..662ea26 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -362,7 +362,6 @@ struct ide_cmd {
 	unsigned int		cursg_ofs;
 
 	struct request		*rq;		/* copy of request */
-	void			*special;	/* valid_t generally */
 };
 
 /* ATAPI packet command flags */
-- 
1.6.0.2

