Return-Path: <linux-kernel-owner+w=401wt.eu-S1761518AbYEESnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761518AbYEESnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761636AbYEESap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:30:45 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55307 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761623AbYEESao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:30:44 -0400
Date: Mon, 5 May 2008 21:29:37 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@sunset.davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] unexport uts_sem
Message-ID: <20080505182937.GZ17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the removal of the Solaris binary emulation the export of 
uts_sem became unused.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>

---

This patch has been sent on:
- 23 Apr 2008

e15db7b262fd8c3d9000e7d5e7a2b1d720fba8de diff --git a/kernel/sys.c b/kernel/sys.c
index 6a0cc71..773d4a5 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1331,8 +1331,6 @@ EXPORT_SYMBOL(in_egroup_p);
 
 DECLARE_RWSEM(uts_sem);
 
-EXPORT_SYMBOL(uts_sem);
-
 asmlinkage long sys_newuname(struct new_utsname __user * name)
 {
 	int errno = 0;


