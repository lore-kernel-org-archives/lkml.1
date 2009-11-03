Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbZKCR6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbZKCR6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbZKCR6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:58:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:47231 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbZKCR6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:58:15 -0500
Date: Tue, 3 Nov 2009 17:57:34 GMT
From: tip-bot for Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tfransosi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tfransosi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257254925-5423-1-git-send-email-tfransosi@gmail.com>
References: <1257254925-5423-1-git-send-email-tfransosi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Clean up trivial style issues in builtin-help.c
Message-ID: <tip-c1e530178540df26eb39f10a972d06f96302ceb4@git.kernel.org>
Git-Commit-ID: c1e530178540df26eb39f10a972d06f96302ceb4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1e530178540df26eb39f10a972d06f96302ceb4
Gitweb:     http://git.kernel.org/tip/c1e530178540df26eb39f10a972d06f96302ceb4
Author:     Thiago Farina <tfransosi@gmail.com>
AuthorDate: Tue, 3 Nov 2009 08:28:45 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 3 Nov 2009 18:37:29 +0100

perf: Clean up trivial style issues in builtin-help.c

Pointed out by checkpatch.

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
Cc: Valdis.Kletnieks@vt.edu
LKML-Reference: <1257254925-5423-1-git-send-email-tfransosi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-help.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 4fb8734..768f9c8 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -61,8 +61,7 @@ static const char *get_man_viewer_info(const char *name)
 {
 	struct man_viewer_info_list *viewer;
 
-	for (viewer = man_viewer_info_list; viewer; viewer = viewer->next)
-	{
+	for (viewer = man_viewer_info_list; viewer; viewer = viewer->next) {
 		if (!strcasecmp(name, viewer->name))
 			return viewer->info;
 	}
@@ -115,7 +114,7 @@ static int check_emacsclient_version(void)
 	return 0;
 }
 
-static void exec_woman_emacs(const char* path, const char *page)
+static void exec_woman_emacs(const char *path, const char *page)
 {
 	if (!check_emacsclient_version()) {
 		/* This works only with emacsclient version >= 22. */
@@ -129,7 +128,7 @@ static void exec_woman_emacs(const char* path, const char *page)
 	}
 }
 
-static void exec_man_konqueror(const char* path, const char *page)
+static void exec_man_konqueror(const char *path, const char *page)
 {
 	const char *display = getenv("DISPLAY");
 	if (display && *display) {
@@ -157,7 +156,7 @@ static void exec_man_konqueror(const char* path, const char *page)
 	}
 }
 
-static void exec_man_man(const char* path, const char *page)
+static void exec_man_man(const char *path, const char *page)
 {
 	if (!path)
 		path = "man";
@@ -364,9 +363,8 @@ static void show_man_page(const char *perf_cmd)
 
 	setup_man_path();
 	for (viewer = man_viewer_list; viewer; viewer = viewer->next)
-	{
 		exec_viewer(viewer->name, page); /* will return when unable */
-	}
+
 	if (fallback)
 		exec_viewer(fallback, page);
 	exec_viewer("man", page);
