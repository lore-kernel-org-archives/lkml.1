Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbXI1H2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbXI1H2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 03:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbXI1H2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 03:28:06 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47557 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbXI1H2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 03:28:05 -0400
Message-ID: <46FCACFC.3010103@bull.net>
Date: Fri, 28 Sep 2007 09:27:56 +0200
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [resend][PATCH] Remove duplicated declarations in procfs
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 28/09/2007 09:34:08,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 28/09/2007 09:34:09,
	Serialize complete at 28/09/2007 09:34:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Pierre Peiffer <pierre.peiffer@bull.net>

This is a trivial patch that removes some duplicated declarations of
extern variables.

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
Pierre
