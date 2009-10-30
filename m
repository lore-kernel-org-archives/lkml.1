Return-Path: <linux-kernel-owner+w=401wt.eu-S932593AbZJ3QT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbZJ3QT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 12:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932449AbZJ3QTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 12:19:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:58185 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336AbZJ3QTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 12:19:24 -0400
Date: Fri, 30 Oct 2009 16:19:02 GMT
From: tip-bot for Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org, lihong.hi@gmail.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, lihong.hi@gmail.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20091027065733.GB22032@uhli>
References: <20091027065733.GB22032@uhli>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Correct the check for number of arguments in recordmcount.pl
Message-ID: <tip-e2d753fac5b3954a3b6001f98479f0435fe7c868@git.kernel.org>
Git-Commit-ID: e2d753fac5b3954a3b6001f98479f0435fe7c868
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2d753fac5b3954a3b6001f98479f0435fe7c868
Gitweb:     http://git.kernel.org/tip/e2d753fac5b3954a3b6001f98479f0435fe7c868
Author:     Li Hong <lihong.hi@gmail.com>
AuthorDate: Tue, 27 Oct 2009 14:57:33 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 29 Oct 2009 15:11:41 -0400

tracing: Correct the check for number of arguments in recordmcount.pl

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
