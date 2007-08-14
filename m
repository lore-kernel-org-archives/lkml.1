Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbXHNVZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbXHNVZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXHNVWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:22:22 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38399 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752078AbXHNVWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:22:19 -0400
Date: Tue, 14 Aug 2007 23:22:10 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ram Pai <linuxram@us.ibm.com>, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fix export_report.pl
Message-ID: <20070814212210.GW18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an annoying bug of export_report.pl missing the usages 
of some exports.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
061222c0c3acfd3bbac143f4e31e09a0711bfeb8 
diff --git a/scripts/export_report.pl b/scripts/export_report.pl
index 9ed00d9..08ceb42 100644
--- a/scripts/export_report.pl
+++ b/scripts/export_report.pl
@@ -112,7 +112,7 @@ foreach my $thismod (@allcfiles) {
 			next;
 		}
 		if ($state eq 2) {
-			if ( $_ !~ /0x[0-9a-f]{7,8},/ ) {
+			if ( $_ !~ /0x[0-9a-f]+,/ ) {
 				next;
 			}
 			my $sym = (split /([,"])/,)[4];

