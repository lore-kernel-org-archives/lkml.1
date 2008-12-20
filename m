Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbYLTOfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbYLTOfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYLTOae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:30:34 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:41310 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbYLTOaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:30:09 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Bernhard Reutner-Fischer <rep.dot.nop@gmail.com>
Subject: [PATCH 09/26] kconfig: fix options to check-lxdialog.sh
Date: Sat, 20 Dec 2008 15:31:20 +0100
Message-Id: <1229783497-19550-9-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081220142518.GA19390@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As noted by Bernhard - fix it up.

Cc: Bernhard Reutner-Fischer <rep.dot.nop@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/lxdialog/check-lxdialog.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index 5552154..fcef0f5 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -52,7 +52,7 @@ EOF
 }
 
 usage() {
-	printf "Usage: $0 [-check compiler options|-header|-library]\n"
+	printf "Usage: $0 [-check compiler options|-ccflags|-ldflags compiler options]\n"
 }
 
 if [ $# -eq 0 ]; then
-- 
1.6.0.2.GIT

