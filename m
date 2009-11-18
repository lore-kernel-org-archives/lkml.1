Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbZKRO4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbZKRO4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbZKRO4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:56:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50777 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752725AbZKRO4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:56:18 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] selinux: Fix warnings
To: jmorris@namei.org, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:39:51 +0000
Message-ID: <20091118143951.4691.33970.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/selinux/genheaders/genheaders.c:20: warning: no previous prototype  
for ‘usage’
scripts/selinux/genheaders/genheaders.c:26: warning: no previous prototype
for ‘stoupperx’

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 scripts/selinux/genheaders/genheaders.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/scripts/selinux/genheaders/genheaders.c b/scripts/selinux/genheaders/genheaders.c
index 3b16145..771b86f 100644
--- a/scripts/selinux/genheaders/genheaders.c
+++ b/scripts/selinux/genheaders/genheaders.c
@@ -17,13 +17,13 @@ struct security_class_mapping {
 
 const char *progname;
 
-void usage(void)
+static void usage(void)
 {
 	printf("usage: %s flask.h av_permissions.h\n", progname);
 	exit(1);
 }
 
-char *stoupperx(const char *s)
+static char *stoupperx(const char *s)
 {
 	char *s2 = strdup(s);
 	char *p;

