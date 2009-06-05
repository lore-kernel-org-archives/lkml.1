Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbZFEXrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbZFEXrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbZFEXly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:54 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:45066 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbZFEXlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:12 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 35/39] kbuild: add hint about __refdata to modpost
Date: Sat,  6 Jun 2009 01:42:53 +0200
Message-Id: <1244245377-17441-35-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As requested by Guennadi Liakhovetski

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 94e71ef..4522948 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1196,7 +1196,7 @@ static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
 		"The variable %s references\n"
 		"the %s %s%s%s\n"
 		"If the reference is valid then annotate the\n"
-		"variable with __init* (see linux/init.h) "
+		"variable with __init* or __refdata (see linux/init.h) "
 		"or name the variable:\n",
 		fromsym, to, sec2annotation(tosec), tosym, to_p);
 		while (*s)
-- 
1.6.3.rc3.40.g75b44

