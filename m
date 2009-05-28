Return-Path: <linux-kernel-owner+w=401wt.eu-S1762474AbZE1Bgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762474AbZE1Bgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 21:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761238AbZE1Bg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 21:36:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:60703 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760494AbZE1BgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 21:36:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=CYQFCLBj9JYcyV1Jv/JmIn1ETXkO97g/aPVcU/Mr+4iO0FBr7nUiHNYo1Pjkr3IP49
         cuzCJ0qEPBVVPJDvwPhQZiOT2P+BYY297NvQHlJsrgJg/+9Z1y8ochTyy/vTouzsowiT
         X82AlT78MREbyp92kn7fYYSQPbUQPKyawYTy4=
Subject: [RESEND] [PATCH 2/2 V3] sched: fix typo in sched-rt-group.txt file
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       tglx <tglx@linutronix.de>, williams <williams@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1242884360.31161.77.camel@centos51>
References: <1242884360.31161.77.camel@centos51>
Content-Type: text/plain
Organization: Private
Date: Thu, 28 May 2009 10:36:14 +0900
Message-Id: <1243474574.14685.38.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




>From c2e8f308730c87010d50a72f80ede6b7f308497e Mon Sep 17 00:00:00 2001
From: GeunSik,Lim <leemgs1@gmail.com>
Date: Thu, 28 May 2009 09:59:46 +0900
Subject: [PATCH 2/2] sched: fix typo in sched-rt-group.txt file

Fix typo about static priority's range.

    Kernel Space                     User Space
    ===============================================================
      0(high) to  98(low)     user RT priority 99(high) to 1(low)
                              with SCHED_RR or SCHED_FIFO
    ---------------------------------------------------------------
     99                       sched_priority is not used in scheduling
                              decisions(it must be specified as 0)
    ---------------------------------------------------------------
    100(high) to 139(low)     user nice -20(high) to 19(low)
    ---------------------------------------------------------------
    140                       idle task priority
    ---------------------------------------------------------------
    * ref) http://www.kernel.org/doc/man-pages/online/pages/man2/sched_setscheduler.2.html

    Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
    Reviewed-by: Ingo Molnar <mingo@elte.hu>
    CC: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/scheduler/sched-rt-group.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
index 5ba4d3f..1537146 100644
--- a/Documentation/scheduler/sched-rt-group.txt
+++ b/Documentation/scheduler/sched-rt-group.txt
@@ -169,7 +169,7 @@ get their allocated time.
 
 Implementing SCHED_EDF might take a while to complete. Priority Inheritance is
 the biggest challenge as the current linux PI infrastructure is geared towards
-the limited static priority levels 0-139. With deadline scheduling you need to
+the limited static priority levels 0-99. With deadline scheduling you need to
 do deadline inheritance (since priority is inversely proportional to the
 deadline delta (deadline - now).
 
-- 
1.6.3.1



-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim (  S A M S U N G     E L E C T R O N I C S  )
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://blog.naver.com/invain/
-----------------------------------------------

