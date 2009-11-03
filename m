Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZKCNfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZKCNfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 08:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZKCNfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 08:35:23 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:61681 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbZKCNfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 08:35:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=shugApi362GQ+rLnHd6Z27pa3vZDBCkWGK7rxRWOnoGgjyMgvP3w68bUYt3KCZ1vU6
         NLRqejNi3+TKrCv8LWrQ+RPlVIyF5ySaJG/vQtKDaR0c02/pNBuwwzzYpoyQrBw/bDPz
         NRUeHgxuzJ//pXPLPP8u0hMMvScCLWq3LrxY8=
From: Thiago Farina <tfransosi@gmail.com>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org, Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH] perf: fix trivial checkpatch errors in builtin-help.
Date: Tue,  3 Nov 2009 08:28:45 -0500
Message-Id: <1257254925-5423-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.5.1.61.ge79999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
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
-- 
1.6.5.1.61.ge79999

