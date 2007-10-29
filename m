Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbXJ2C4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbXJ2C4O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 22:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbXJ2C4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 22:56:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39497 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbXJ2Cz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 22:55:59 -0400
Date: Mon, 29 Oct 2007 13:55:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <sfrench@samba.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-cifs-client@lists.samba.org
Subject: [PATCH] [CIFS] Silence two "defined but unused" warning
Message-Id: <20071029135558.f80876d8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/cifs/cifssmb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index f0d9a48..aa9dc9e 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2486,6 +2486,7 @@ querySymLinkRetry:
 	return rc;
 }
 
+#ifdef CONFIG_CIFS_EXPERIMENTAL
 /* Initialize NT TRANSACT SMB into small smb request buffer.
    This assumes that all NT TRANSACTS that we init here have
    total parm and data under about 400 bytes (to fit in small cifs
@@ -2569,6 +2570,7 @@ validate_ntransact(char *buf, char **ppparm, char **ppdata,
 	}
 	return 0;
 }
+#endif /* CONFIG_CIFS_EXPERIMENTAL */
 
 int
 CIFSSMBQueryReparseLinkInfo(const int xid, struct cifsTconInfo *tcon,
-- 
1.5.3.4

