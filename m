Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYGVRWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYGVRWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbYGVRVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:21:35 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59937 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039AbYGVRVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:21:34 -0400
Date: Tue, 22 Jul 2008 20:21:23 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Eric Paris <eparis@redhat.com>, sds@tycho.nsa.gov, jmorris@namei.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make selinux_write_opts() static
Message-ID: <20080722172123.GX14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global selinux_write_opts() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
b75a9f11d832d4f819b69f02b615c53889faec09 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 63f131f..3179e40 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -957,7 +957,8 @@ out_err:
 	return rc;
 }
 
-void selinux_write_opts(struct seq_file *m, struct security_mnt_opts *opts)
+static void selinux_write_opts(struct seq_file *m,
+			       struct security_mnt_opts *opts)
 {
 	int i;
 	char *prefix;

