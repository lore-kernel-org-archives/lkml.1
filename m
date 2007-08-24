Return-Path: <linux-kernel-owner+w=401wt.eu-S1761994AbXHXVGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761994AbXHXVGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbXHXVGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:06:10 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60118 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754505AbXHXVGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:06:09 -0400
Date: Fri, 24 Aug 2007 23:04:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Ram Pai <linuxram@us.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fix export_report.pl
Message-ID: <20070824210451.GE30705@stusta.de>
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

This patch has been sent on:
- 14 Aug 2007

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

