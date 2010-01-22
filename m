Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648Ab0AVKZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0AVKZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 05:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615Ab0AVKZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 05:25:50 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:58642 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab0AVKZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 05:25:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :x-operating-system:user-agent;
        b=n+T+4V4yILmKh6YGOXJy95Cyz6iAH9Kn4SL3YUemr0awDNkS1kZeeoqpoHv/EqlF07
         eiE82eAOAmPaVmjNhEWEADTm+JfKgIQvno8q1dgEFkhYL7BrRumK4AFFBKQfy0Wm1aq2
         ARgPI45fDChgc4InAwU3vm8S1TODQQ5lRa0Do=
Date: Fri, 22 Jan 2010 18:25:41 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Replace the extended ASCII copyright char to normal
 ASCII sequence
Message-ID: <20100122102541.GA21430@xhl>
Mail-Followup-To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Operating-System: Linux xhl 2.6.31-14-generic
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A copyright extended ASCII char (0xa9) in kernel/perf_event.c makes my utf-8
compatible vim think it is a binary file. It is better to either use a utf-8
sequence 0xc20xa9 or just normal copyright ASCII chars '(C)'.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
Cc: Paul Mackerras <paulus@au1.ibm.com>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index d27746b..4b8fbd9 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4,7 +4,7 @@
  *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
  *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
  *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
- *  Copyright  ©  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
+ *  Copyright (C) 2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
  *
  * For licensing details see kernel-base/COPYING
  */
-- 
1.6.3.3


