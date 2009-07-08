Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbZGHIWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbZGHIWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 04:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbZGHIWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 04:22:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48307 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbZGHIWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 04:22:38 -0400
Date: Wed, 8 Jul 2009 10:22:33 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: srostedt@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: scripts/recordmcount.pl doc question
Message-ID: <20090708082233.GA3234@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was reading throught the recordmcount.pl starting comment,
and spot a tiny discrepancy. 

The second example is about my_func not being global, but the example code 
has the ".globl my_func" statement just moved. IMO it should be erased,
if not I'm curious what I'm missing.. :)

wbr,
jirka


diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 7109e2b..db4ebe1 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -57,7 +57,6 @@
 #        call mcount  (offset: 0x5)
 #        [...]
 #        ret
-#  .globl my_func
 #  other_func:
 #        [...]
 #        call mcount (offset: 0x1b)
