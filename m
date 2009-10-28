Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbZJ1FDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbZJ1FDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbZJ1FDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:03:36 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:39763 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777AbZJ1FDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:03:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=Az9zYvUModCzivn33ngeQGcYwCeGn5+wX12MdW5FzgjAJI89wwRmXZUA3LxriPxk3C
         EAcoZGNBS2b/WWqpHrSJazEYMYZF09T0cPaudzT30w1dqvobFI3W08IMlai9QMRRCJ5Y
         Mv+ij3m+eDCM1zOGFkrLEFS480l7xHvJcct30=
Date: Wed, 28 Oct 2009 13:03:32 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/8] tracing: recordmcount.pl Support absolute path
	check on $inputfile 
Message-ID: <20091028050332.GC30758@uhli>
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

>From 6352a90805b18e4b567c3dcdd438e3828e478734 Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Tue, 27 Oct 2009 12:32:18 +0800
Subject: [PATCH] tracing: recordmcount.pl Support absolute path check on $inputfile

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 scripts/recordmcount.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 9e0ec8e..8ff9eab 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -123,7 +123,7 @@ my ($arch, $bits, $objdump, $objcopy, $cc,
     $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
 
 # This file refers to mcount and shouldn't be ftraced, so lets' ignore it
-if ($inputfile eq "kernel/trace/ftrace.o") {
+if ($inputfile =~ m,kernel/trace/ftrace\.o$,) {
     exit(0);
 }
 
-- 
1.6.0.4

