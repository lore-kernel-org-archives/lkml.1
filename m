Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932Ab0AXXWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0AXXWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797Ab0AXXWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:22:16 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:44387 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab0AXXWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:22:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KZVt894LGUm3pRV6HP6RpZm42rA0eXvhdAL+eUBeCV3lpIGmDdOADcS74Ym1jCcVh7
         FD8bT6jSBWzLzqK/NbNqGqHFON99+K1x7VYAW0dqu0RHN5/TnZ50MqItf674eQ9oEGSD
         6nTAFYQLBGnc1qWRtan4BV2qr3zfnTU0lK2Ws=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH] tools/perf/perf.c: Clean up trivial style issues.
Date: Sun, 24 Jan 2010 18:21:46 -0500
Message-Id: <6da2dcba6dce85a338cfe948591db4da4957257b.1264374841.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.6.1.436.gaba7d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checked with:
./../scripts/checkpatch.pl --terse --file perf.c

perf.c:51: ERROR: open brace '{' following function declarations go on the next line
perf.c:73: ERROR: "foo*** bar" should be "foo ***bar"
perf.c:112: ERROR: space prohibited before that close parenthesis ')'
perf.c:127: ERROR: space prohibited before that close parenthesis ')'
perf.c:171: ERROR: "foo** bar" should be "foo **bar"
perf.c:213: ERROR: "(foo*)" should be "(foo *)"
perf.c:216: ERROR: "(foo*)" should be "(foo *)"
perf.c:217: ERROR: space required before that '*' (ctx:OxV)
perf.c:452: ERROR: do not initialise statics to 0 or NULL
perf.c:453: ERROR: do not initialise statics to 0 or NULL

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 tools/perf/perf.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 873e55f..948a8f5 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -48,7 +48,8 @@ int check_pager_config(const char *cmd)
 	return c.val;
 }
 
-static void commit_pager_choice(void) {
+static void commit_pager_choice(void)
+{
 	switch (use_pager) {
 	case 0:
 		setenv("PERF_PAGER", "cat", 1);
@@ -70,7 +71,7 @@ static void set_debugfs_path(void)
 		 "tracing/events");
 }
 
-static int handle_options(const char*** argv, int* argc, int* envchanged)
+static int handle_options(const char ***argv, int *argc, int *envchanged)
 {
 	int handled = 0;
 
@@ -109,7 +110,7 @@ static int handle_options(const char*** argv, int* argc, int* envchanged)
 				*envchanged = 1;
 		} else if (!strcmp(cmd, "--perf-dir")) {
 			if (*argc < 2) {
-				fprintf(stderr, "No directory given for --perf-dir.\n" );
+				fprintf(stderr, "No directory given for --perf-dir.\n");
 				usage(perf_usage_string);
 			}
 			setenv(PERF_DIR_ENVIRONMENT, (*argv)[1], 1);
@@ -124,7 +125,7 @@ static int handle_options(const char*** argv, int* argc, int* envchanged)
 				*envchanged = 1;
 		} else if (!strcmp(cmd, "--work-tree")) {
 			if (*argc < 2) {
-				fprintf(stderr, "No directory given for --work-tree.\n" );
+				fprintf(stderr, "No directory given for --work-tree.\n");
 				usage(perf_usage_string);
 			}
 			setenv(PERF_WORK_TREE_ENVIRONMENT, (*argv)[1], 1);
@@ -168,7 +169,7 @@ static int handle_alias(int *argcp, const char ***argv)
 {
 	int envchanged = 0, ret = 0, saved_errno = errno;
 	int count, option_count;
-	const char** new_argv;
+	const char **new_argv;
 	const char *alias_command;
 	char *alias_string;
 
@@ -210,11 +211,11 @@ static int handle_alias(int *argcp, const char ***argv)
 		if (!strcmp(alias_command, new_argv[0]))
 			die("recursive alias: %s", alias_command);
 
-		new_argv = realloc(new_argv, sizeof(char*) *
+		new_argv = realloc(new_argv, sizeof(char *) *
 				    (count + *argcp + 1));
 		/* insert after command name */
-		memcpy(new_argv + count, *argv + 1, sizeof(char*) * *argcp);
-		new_argv[count+*argcp] = NULL;
+		memcpy(new_argv + count, *argv + 1, sizeof(char *) * *argcp);
+		new_argv[count + *argcp] = NULL;
 
 		*argv = new_argv;
 		*argcp += count - 1;
@@ -449,8 +450,8 @@ int main(int argc, const char **argv)
 	setup_path();
 
 	while (1) {
-		static int done_help = 0;
-		static int was_alias = 0;
+		static int done_help;
+		static int was_alias;
 
 		was_alias = run_argv(&argc, &argv);
 		if (errno != ENOENT)
-- 
1.6.6.1.436.gaba7d

