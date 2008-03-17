Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbYCQU3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbYCQU3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbYCQU3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:29:44 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:56002 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbYCQU3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:29:43 -0400
Date: Mon, 17 Mar 2008 22:29:23 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       Casey Schaufler <casey@schaufler-ca.com>,
       James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make selinux_parse_opts_str() static
Message-ID: <20080317202923.GC9550@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global selinux_parse_opts_str() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
42740a04634e3a4362a688b29ad31ee87c940ff7 diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 4bf4807..41a049f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -800,7 +800,8 @@ static void selinux_sb_clone_mnt_opts(const struct super_block *oldsb,
 	mutex_unlock(&newsbsec->lock);
 }
 
-int selinux_parse_opts_str(char *options, struct security_mnt_opts *opts)
+static int selinux_parse_opts_str(char *options,
+				  struct security_mnt_opts *opts)
 {
 	char *p;
 	char *context = NULL, *defcontext = NULL;

