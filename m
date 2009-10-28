Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbZJ1FCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbZJ1FCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbZJ1FCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:02:41 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:38310 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbZJ1FCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:02:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=P1XvtKTaAjh/OXqOwoZLBKJFVo1gZX5Vuw8kKJmA/QIoYz15b3TSRSWyd0MKcewLUF
         VbCbLA24LqOaZBF5jhsg5IbG8DeslHx2uXp0TPdq2JBxs30vaUItowb16eGOKt8fVwEq
         o0he6/D8IBQTzjyxWQwd25EAk97gHQg8PazDQ=
Date: Wed, 28 Oct 2009 13:02:34 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/8] tracing: recordmcount.pl Correct the check on the
	number of parameters
Message-ID: <20091028050234.GB30758@uhli>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
References: <20091028045532.GA30036@uhli>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028045532.GA30036@uhli>
X-Operating-System: Linux uhli 2.6.28-11-generic 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f39257ad204c26198beb85c9c1133f610f8b0117 Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Tue, 27 Oct 2009 12:27:32 +0800
Subject: [PATCH] tracing: recordmcount.pl Correct the check on the number of parameters

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 scripts/recordmcount.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 9e7ceca..9e0ec8e 100755
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
1.6.0.4

