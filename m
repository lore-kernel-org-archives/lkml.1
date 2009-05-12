Return-Path: <linux-kernel-owner+w=401wt.eu-S1760428AbZELJxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428AbZELJxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758537AbZELJwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:52:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:32154 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbZELJwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:52:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer;
        b=fOo8z5zTmJBuTeC7pwaxzImNZD2ix+rFKL8ZJuA+om/zag2JA++AEccDjeY9TKmH5j
         AnlVpxp4RZ3CKaH4jUSjxCyI4N0ZOEDNwico9RYGXtoDqJsawo9cBc5XF6+rDpQtOFDG
         ldhXA5QdaMjOJbkp3HRuZLh5bRulKuj+i336I=
Subject: [PATCH]sched: fix typo in sched-rt-group.txt file
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       tglx <tglx@linutronix.de>, williams <williams@redhat.com>,
       a.p.zijlstra@chello.nl
Content-Type: multipart/mixed; boundary="=-9amiSwTwJ4yBkhGS20Rt"
Organization: Private
Date: Tue, 12 May 2009 17:37:39 +0900
Message-Id: <1242117459.31161.11.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9amiSwTwJ4yBkhGS20Rt
Content-Type: text/plain
Content-Transfer-Encoding: 7bit




Dear Ingo,

I found typo about the range of static priority ( = realtime priority )
in "./Documentation/scheduler/sched-rt-group.txt" file.

If I don't understand static priority levels, Correct me.


commit d6af702008117ca489a2f5476239d1688a517e98
Author: GeunSik,Lim <leemgs1@gmail.com>
Date:   Tue May 12 17:20:32 2009 +0900

    sched: fix typo in sched-rt-group.txt file
    
    Fix typo about static priority's range.
     Kernel Space priority: 0   to 99   --> User Space RT priority 99 to 0
     Kernel Space priority: 100 to 139  --> User Space nice -20 to 19
    
    Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>

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
 


-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim (ELS - OS Group - S/W Lab - SAIT - SAMSUNG)
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://intomail.dnip.net/invain/me/
-----------------------------------------------

--=-9amiSwTwJ4yBkhGS20Rt
Content-Disposition: attachment; filename=fix-typo-static-priority-levels.patch
Content-Type: text/x-patch; name=fix-typo-static-priority-levels.patch; charset=euckr
Content-Transfer-Encoding: 7bit

commit d6af702008117ca489a2f5476239d1688a517e98
Author: GeunSik,Lim <leemgs1@gmail.com>
Date:   Tue May 12 17:20:32 2009 +0900

    sched: fix typo in sched-rt-group.txt file
    
    Fix typo about static priority's range.
     Kernel Space priority: 0   to 99   --> User Space RT priority 99 to 0
     Kernel Space priority: 100 to 139  --> User Space nice -20 to 19
    
    Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>

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
 

--=-9amiSwTwJ4yBkhGS20Rt--

