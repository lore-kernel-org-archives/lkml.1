Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZKLSsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZKLSsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbZKLSsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:48:19 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:12394 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbZKLSsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:48:17 -0500
Subject: [PATCH 07/11] cciss: fix typo that causes scsi status to be lost.
To: axboe@kernel.dk, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, achiang@hp.com,
       brace@beardog.cce.hp.com
Date: Thu, 12 Nov 2009 12:49:45 -0600
Message-ID: <20091112184945.23389.586.stgit@beardog.cce.hp.com>
In-Reply-To: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
References: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: fix typo that causes scsi status to be lost.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss_scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 3315268..237d2b3 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -755,7 +755,7 @@ complete_scsi_command( CommandList_struct *cp, int timeout, __u32 tag)
                         			cp,  
 						ei->ScsiStatus); 
 #endif
-					cmd->result |= (ei->ScsiStatus < 1);
+					cmd->result |= (ei->ScsiStatus << 1);
                 		}
 				else {  /* scsi status is zero??? How??? */
 					

