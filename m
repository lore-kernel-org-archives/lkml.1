Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbXJWCmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbXJWCmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 22:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbXJWCmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 22:42:32 -0400
Received: from rwcrmhc12.comcast.net ([204.127.192.82]:48338 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbXJWCmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 22:42:31 -0400
Date: Mon, 22 Oct 2007 22:42:25 -0400 (EDT)
From: Parag Warudkar <parag@comcast.net>
X-X-Sender: parag@parag-desktop
To: sfrench@samba.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] cifssmb.c: Wrap unused functions in appropriate #ifdef
Message-ID: <alpine.DEB.0.99.0710222235590.16793@parag-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


fs/cifs/cifssmb.c - get rid of couple of unused function warnings which 
show up when CONFIG_CIFS_EXPERIMENTAL is not defined - wrap them in 
#ifdef CONFIG_CIFS_EXPERIMENTAL. Patch against current git.

Signed-off-by: Parag Warudkar <kernel-stuff@comcast.net>

--- linux-2.6-wk/fs/cifs/cifssmb.c.orig	2007-10-21 19:12:53.000000000 -0400
+++ linux-2.6-wk/fs/cifs/cifssmb.c	2007-10-22 22:19:27.000000000 -0400
@@ -2485,7 +2485,7 @@
  		goto querySymLinkRetry;
  	return rc;
  }
-
+#ifdef CONFIG_CIFS_EXPERIMENTAL
  /* Initialize NT TRANSACT SMB into small smb request buffer.
     This assumes that all NT TRANSACTS that we init here have
     total parm and data under about 400 bytes (to fit in small cifs
@@ -2569,6 +2569,7 @@
  	}
  	return 0;
  }
+#endif

  int
  CIFSSMBQueryReparseLinkInfo(const int xid, struct cifsTconInfo *tcon,
