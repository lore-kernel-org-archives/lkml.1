Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbYAANrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbYAANrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 08:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbYAANq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 08:46:59 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:53717 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbYAANq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:46:58 -0500
Date: Tue, 1 Jan 2008 15:46:44 +0200
From: Adrian Bunk <bunk@kernel.org>
To: sfrench@samba.org
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] CIFS: #if 0 mode_to_access_flags()
Message-ID: <20080101134644.GE2360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch #if 0's the unused mode_to_access_flags(), fixing the 
following compile warning:

<--  snip  -->

...
  CC      fs/cifs/cifsacl.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/cifs/cifsacl.c:200: warning: ‘mode_to_access_flags’ defined but not used
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/cifs/cifsacl.c |    2 ++
 1 file changed, 2 insertions(+)

0cf530f754b974ee5e58b3346828bb5586440c92 
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index c312adc..771a22f 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -189,6 +189,7 @@ static void access_flags_to_mode(__le32 ace_flags, int type, umode_t *pmode,
 	return;
 }
 
+#if 0
 /*
    Generate access flags to reflect permissions mode is the existing mode.
    This function is called for every ACE in the DACL whose SID matches
@@ -219,6 +220,7 @@ static void mode_to_access_flags(umode_t mode, umode_t bits_to_use,
 #endif
 	return;
 }
+#endif  /*  0  */
 
 
 #ifdef CONFIG_CIFS_DEBUG2

