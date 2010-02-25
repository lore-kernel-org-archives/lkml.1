Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab0BYRkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:40:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933055Ab0BYRkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:40:52 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH][trace-cmd] trace-record: wrong refferencing
Date: Thu, 25 Feb 2010 18:40:47 +0100
Message-Id: <1267119647-16775-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

looks like bug this time :)

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
diff --git a/trace-record.c b/trace-record.c
index cdfc857..2a754b9 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -116,7 +116,7 @@ struct tracecmd_recorder *tracecmd_create_recorder(const char *file, int cpu)
 	int fd;
 
 	fd = open(file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
-	if (recorder->fd < 0)
+	if (fd < 0)
 		return NULL;
 
 	recorder = tracecmd_create_recorder_fd(fd, cpu);
