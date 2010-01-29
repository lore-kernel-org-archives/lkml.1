Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862Ab0A2JdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab0A2JdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807Ab0A2JdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:33:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:36731 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab0A2JdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:33:03 -0500
Date: Fri, 29 Jan 2010 09:32:31 GMT
From: tip-bot for Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tfransosi@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tfransosi@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <1264633557-17597-7-git-send-email-acme@infradead.org>
References: <1264633557-17597-7-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/perf.c: Clean up trivial style issues
Message-ID: <tip-d7eeea995561a11e1a788398beb003a619e98990@git.kernel.org>
Git-Commit-ID: d7eeea995561a11e1a788398beb003a619e98990
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:32:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7eeea995561a11e1a788398beb003a619e98990
Gitweb:     http://git.kernel.org/tip/d7eeea995561a11e1a788398beb003a619e98990
Author:     Thiago Farina <tfransosi@gmail.com>
AuthorDate: Wed, 27 Jan 2010 21:05:55 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:20:59 +0100

tools/perf/perf.c: Clean up trivial style issues

Checked with:
./../scripts/checkpatch.pl --terse --file perf.c

 perf.c: 51: ERROR: open brace '{' following function declarations go on the next line
 perf.c: 73: ERROR: "foo*** bar" should be "foo ***bar"
 perf.c:112: ERROR: space prohibited before that close parenthesis ')'
 perf.c:127: ERROR: space prohibited before that close parenthesis ')'
 perf.c:171: ERROR: "foo** bar" should be "foo **bar"
 perf.c:213: ERROR: "(foo*)" should be "(foo *)"
 perf.c:216: ERROR: "(foo*)" should be "(foo *)"
 perf.c:217: ERROR: space required before that '*' (ctx:OxV)
 perf.c:452: ERROR: do not initialise statics to 0 or NULL
 perf.c:453: ERROR: do not initialise statics to 0 or NULL

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <1264633557-17597-7-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/perf.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 05c861c..109b89b 100644
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
@@ -450,8 +451,8 @@ int main(int argc, const char **argv)
 	setup_path();
 
 	while (1) {
-		static int done_help = 0;
-		static int was_alias = 0;
+		static int done_help;
+		static int was_alias;
 
 		was_alias = run_argv(&argc, &argv);
 		if (errno != ENOENT)
