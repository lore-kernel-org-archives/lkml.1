Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbZA3PIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbZA3PIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 10:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbZA3PFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 10:05:37 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60195 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbZA3PFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 10:05:36 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 6/8] checkpatch: extend attribute testing to all modifiers
Date: Fri, 30 Jan 2009 15:05:18 +0000
Message-Id: <1233327920-16691-7-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.1.2.419.g0d87e
In-Reply-To: <1233327920-16691-1-git-send-email-apw@canonical.com>
References: <1233327920-16691-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should allow testing of all modifiers not just attributes.  Extend
testing and test for all the know modifiers.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b9e9ee1..0dcfdce 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1584,9 +1584,9 @@ sub process {
 		}
 # TEST: allow direct testing of the attribute matcher.
 		if ($dbg_attr) {
-			if ($line =~ /^.\s*$Attribute\s*$/) {
+			if ($line =~ /^.\s*$Modifier\s*$/) {
 				ERROR("TEST: is attr\n" . $herecurr);
-			} elsif ($dbg_attr > 1 && $line =~ /^.+($Attribute)/) {
+			} elsif ($dbg_attr > 1 && $line =~ /^.+($Modifier)/) {
 				ERROR("TEST: is not attr ($1 is)\n". $herecurr);
 			}
 			next;
-- 
1.6.1.2.419.g0d87e

