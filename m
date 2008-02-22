Return-Path: <linux-kernel-owner+w=401wt.eu-S1764394AbYBVUCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764394AbYBVUCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765893AbYBVT7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:59:17 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44811 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765787AbYBVT7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:59:15 -0500
Date: Fri, 22 Feb 2008 21:58:26 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/ns_cgroup.c should #include <linux/nsproxy.h>
Message-ID: <20080222195826.GG1409@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the externs its global 
functions (in this case for ns_cgroup_clone()).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d3446a02068091d59425c51bde1daea777398e44 diff --git a/kernel/ns_cgroup.c b/kernel/ns_cgroup.c
index aead4d6..659f321 100644
--- a/kernel/ns_cgroup.c
+++ b/kernel/ns_cgroup.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/cgroup.h>
 #include <linux/fs.h>
+#include <linux/nsproxy.h>
 
 struct ns_cgroup {
 	struct cgroup_subsys_state css;
