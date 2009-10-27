Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbZJ0G6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbZJ0G6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 02:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756406AbZJ0G6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 02:58:05 -0400
Received: from mail-px0-f180.google.com ([209.85.216.180]:52545 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394AbZJ0G6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 02:58:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=jMOPzG8hVhN8IJuO6Q60uMgrj6AoBnH6LKaHB7nkuQjZgHInnozMHjuPAcLaTmD7t8
         VQ2QTABYWdQL6CBu4ir2OdDFhZwjV8hM7e2+OnfsACF8niaM1IvwhJNcV62MxLb60fgi
         +UBRTMblu2vlqE0qw2knLXLi2mMLmOl93mRps=
Date: Tue, 27 Oct 2009 14:57:33 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] tracing: recordmcount.pl Correct the check on the
	number of parameters
Message-ID: <20091027065733.GB22032@uhli>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
References: <20091027065421.GA22032@uhli>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027065421.GA22032@uhli>
X-Operating-System: Linux uhli 2.6.28-11-generic 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2ee0d7914a95461a19f174085a081bad345cddd5 Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Tue, 27 Oct 2009 12:27:32 +0800
Subject: [PATCH] tracing: recordmcount.pl Correct the check on the number of parameters

Signed-off-by: Li Hong <lihong.hi@gmail.com>

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index ac908b3..0850b83 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -112,7 +112,7 @@ $P =~ s@.*/@@g;
 
 my $V = '0.1';
 
-if ($#ARGV < 7) {
+if ($#ARGV != 10) {
 	print "usage: $P arch bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
 	print "version: $V\n";
 	exit(1);
-- 
1.6.0.4

