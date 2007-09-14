Return-Path: <linux-kernel-owner+w=401wt.eu-S1759693AbXINLtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbXINLtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 07:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758872AbXINLsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 07:48:54 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49299 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441AbXINLsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 07:48:50 -0400
Date: Fri, 14 Sep 2007 13:48:38 +0200
From: Pierre Peiffer <Pierre.Peiffer@bull.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/proc/internal.h cleanup.
Message-Id: <20070914134838.00bc6c4d.Pierre.Peiffer@bull.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 14/09/2007 13:54:33,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 14/09/2007 13:54:35,
	Serialize complete at 14/09/2007 13:54:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Pierre Peiffer <pierre.peiffer@bull.net>

These extern variables are declared twice, so it removes one of the declaration.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
---

 fs/proc/internal.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index b215c35..d812816 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -50,10 +50,6 @@ extern const struct file_operations proc_maps_operations;
 extern const struct file_operations proc_numa_maps_operations;
 extern const struct file_operations proc_smaps_operations;
 
-extern const struct file_operations proc_maps_operations;
-extern const struct file_operations proc_numa_maps_operations;
-extern const struct file_operations proc_smaps_operations;
-
 
 void free_proc_entry(struct proc_dir_entry *de);
 

-- 
Pierre Peiffer
