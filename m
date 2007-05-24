Return-Path: <linux-kernel-owner+w=401wt.eu-S1762760AbXEXBiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762760AbXEXBiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758776AbXEXBhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:37:45 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49333 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758517AbXEXBho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:37:44 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: sam@ravnborg.org
Subject: [patch] use POSIX equality test in check-lxdialog.sh
Date: Wed, 23 May 2007 21:37:45 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705232137.45762.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The "==" operator is not in POSIX, so use -eq instead.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
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
