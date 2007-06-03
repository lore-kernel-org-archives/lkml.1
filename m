Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbXFCUrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbXFCUrA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbXFCUqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:46:15 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52942 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbXFCUqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:46:13 -0400
Date: Sun, 3 Jun 2007 22:47:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: [PATCH 09/19] kconfig: use POSIX equality test in check-lxdialog.sh
Message-ID: <20070603204715.GI9240@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 09/19] kconfig: use POSIX equality test in check-lxdialog.sh
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 23 May 2007 21:37:45 -0400

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
1.5.1.rc3.1544.g8a923


----- End forwarded message -----
