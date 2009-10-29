Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbZJ2Wdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbZJ2Wdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 18:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbZJ2WdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 18:33:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57407 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157AbZJ2WdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:33:15 -0400
Message-Id: <20091029223319.208676391@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 29 Oct 2009 18:32:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Li Hong <lihong.hi@gmail.com>
Subject: [PATCH 2/8] [PATCH 2/8] tracing: Correct the check for number of arguments in recordmcount.pl
References: <20091029223254.504427063@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Correct-the-check-for-number-of-arguments-in.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Hong <lihong.hi@gmail.com>

The number of arguments passed into recordmcount.pl is 10, but the code
checks if only 7 are passed in.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
LKML-Reference: <20091027065733.GB22032@uhli>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index a569be7..a512af1 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -113,7 +113,7 @@ $P =~ s@.*/@@g;
 
 my $V = '0.1';
 
-if ($#ARGV < 7) {
+if ($#ARGV != 10) {
 	print "usage: $P arch bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
 	print "version: $V\n";
 	exit(1);
-- 
1.6.3.3


