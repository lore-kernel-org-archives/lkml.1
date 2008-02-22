Return-Path: <linux-kernel-owner+w=401wt.eu-S932261AbYBVT7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbYBVT7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759787AbYBVT64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:58:56 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:34183 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759549AbYBVT6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:58:55 -0500
Date: Fri, 22 Feb 2008 21:58:07 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul.moore@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make smackfs.c:smk_unlbl_ambient() static
Message-ID: <20080222195807.GB1409@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global smk_unlbl_ambient() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
60c7072cb922cdecdb8a4f08e5710c014e0e8a8c diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 358c92c..7c6e671 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -371,7 +371,7 @@ void smk_cipso_doi(void)
 /**
  * smk_unlbl_ambient - initialize the unlabeled domain
  */
-void smk_unlbl_ambient(char *oldambient)
+static void smk_unlbl_ambient(char *oldambient)
 {
 	int rc;
 	struct netlbl_audit audit_info;
