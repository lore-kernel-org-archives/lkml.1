Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZGXVwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZGXVwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 17:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbZGXVwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 17:52:17 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:40211 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbZGXVwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 17:52:16 -0400
Subject: [PATCH] Resolved all -Wmissing-prototypes warnings in x86 defconfig
From: Trevor Keith <tsrk@tsrk.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Content-Type: text/plain
Date: Fri, 24 Jul 2009 14:43:40 -0700
Message-Id: <1248471821.16421.4.camel@tsrk-ibm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Trevor Keith <tsrk@tsrk.net>
---
 scripts/conmakehash.c     |    6 +++---
 scripts/mod/modpost.c     |    4 ++--
 scripts/selinux/mdp/mdp.c |    4 ++--
 usr/gen_init_cpio.c       |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/scripts/conmakehash.c b/scripts/conmakehash.c
index e0c6891..263a44d 100644
--- a/scripts/conmakehash.c
+++ b/scripts/conmakehash.c
@@ -24,14 +24,14 @@
 
 typedef unsigned short unicode;
 
-void usage(char *argv0)
+static void usage(char *argv0)
 {
   fprintf(stderr, "Usage: \n"
          "        %s chartable [hashsize] [hashstep] [maxhashlevel]\n", argv0);
   exit(EX_USAGE);
 }
 
-int getunicode(char **p0)
+static int getunicode(char **p0)
 {
   char *p = *p0;
 
@@ -49,7 +49,7 @@ unicode unitable[MAX_FONTLEN][255];
 				/* Massive overkill, but who cares? */
 int unicount[MAX_FONTLEN];
 
-void addpair(int fp, int un)
+static void addpair(int fp, int un)
 {
   int i;
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 4522948..801a16a 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -691,7 +691,7 @@ static int number_prefix(const char *sym)
  *   The $ syntax is for sections where ld append a dot number
  *   to make section name unique.
  */
-int match(const char *sym, const char * const pat[])
+static int match(const char *sym, const char * const pat[])
 {
 	const char *p;
 	while (*pat) {
@@ -1746,7 +1746,7 @@ static void add_header(struct buffer *b, struct module *mod)
 	buf_printf(b, "};\n");
 }
 
-void add_staging_flag(struct buffer *b, const char *name)
+static void add_staging_flag(struct buffer *b, const char *name)
 {
 	static const char *staging_dir = "drivers/staging";
 
diff --git a/scripts/selinux/mdp/mdp.c b/scripts/selinux/mdp/mdp.c
index ca757d4..b4ced85 100644
--- a/scripts/selinux/mdp/mdp.c
+++ b/scripts/selinux/mdp/mdp.c
@@ -31,13 +31,13 @@
 
 #include "flask.h"
 
-void usage(char *name)
+static void usage(char *name)
 {
 	printf("usage: %s [-m] policy_file context_file\n", name);
 	exit(1);
 }
 
-void find_common_name(char *cname, char *dest, int len)
+static void find_common_name(char *cname, char *dest, int len)
 {
 	char *start, *end;
 
diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index f1d3fe3..83b3dde 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -446,7 +446,7 @@ static int cpio_mkfile_line(const char *line)
 	return rc;
 }
 
-void usage(const char *prog)
+static void usage(const char *prog)
 {
 	fprintf(stderr, "Usage:\n"
 		"\t%s <cpio_list>\n"
-- 
1.6.0.4


