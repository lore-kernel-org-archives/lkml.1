Return-Path: <linux-kernel-owner+w=401wt.eu-S932546AbXGQOJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbXGQOJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761757AbXGQOHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:07:55 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35923 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760887AbXGQOHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:50 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 07/33] kconfig: use POSIX equality test in check-lxdialog.sh
Date: Tue, 17 Jul 2007 16:08:36 +0200
Message-Id: <11846813431389-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11846813432072-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

The "==" operator is not in POSIX, so use -eq instead.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/lxdialog/check-lxdialog.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index cdca738..9681476 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -51,7 +51,7 @@ usage() {
 	printf "Usage: $0 [-check compiler options|-header|-library]\n"
 }
 
-if [ $# == 0 ]; then
+if [ $# -eq 0 ]; then
 	usage
 	exit 1
 fi
-- 
1.5.0.6

