Return-Path: <linux-kernel-owner+w=401wt.eu-S1763294AbYHEULb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763294AbYHEULb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758688AbYHEULY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:11:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:36598 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYHEULX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:11:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dYKjln7d4wRKdY9maiQnG48I1+8tsS05xU0stpehAvVyOICyJk2pn5A3RLU9wtjcLz
         o7R0InWTZ9Zxp4/RsjmuQEcsNzbnSJVmvs69ZnKUbs3MpIlO4Bo576+iZ2X5a9j+Hh9V
         J+rD2QQtJLEZjM8hLhl8hQnuy+qrPdvSjYVfg=
Date: Wed, 6 Aug 2008 00:10:36 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: mfasheh@suse.com, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2/cluster/netdebug.c: fix warning
Message-ID: <20080805201036.GC17320@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

ocfs2/cluster/netdebug.c: fix warning

fs/ocfs2/cluster/netdebug.c:154: warning: format '%lu' expects
	type 'long unsigned int', but argument 17 has type 'suseconds_t'


Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 fs/ocfs2/cluster/netdebug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index d8bfa0e..cdc0ed2 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -151,7 +151,7 @@ static int nst_seq_show(struct seq_file *seq, void *v)
 			   nst->st_send_time.tv_sec,
 			   (unsigned long)nst->st_send_time.tv_usec,
 			   nst->st_status_time.tv_sec,
-			   nst->st_status_time.tv_usec);
+			   (unsigned long)nst->st_status_time.tv_usec);
 	}
 
 	spin_unlock(&o2net_debug_lock);
