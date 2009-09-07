Return-Path: <linux-kernel-owner+w=401wt.eu-S1752940AbZIGMhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbZIGMhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 08:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbZIGMhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 08:37:45 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:41244 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbZIGMhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 08:37:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WSCSGqV7tGsUDTAhFDrKNs/8FbZbK3SKJnHkB7SCDK+BsdNYynGcgZHeYMwJ63g7i8
         wfh9IsfaYMoYo4FQhpr6IQjv4GkB6S8R1c9eFYo5WNR3GLnEE5R9g85CdS3NjhWrRDM8
         updWbxj0/opCG11y7ePi0AbgM0DqGipZ0P4Ro=
Subject: [PATCH 2/5] debugfs - Change debuhgfs directory of
	trace-events-sample.h
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain
Organization: Private
Date: Mon, 07 Sep 2009 21:37:37 +0900
Message-Id: <1252327057.2153.97.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>From cca4be191d4007f0997117c5e29fa2da73081a25 Mon Sep 17 00:00:00 2001
From: GeunSik,Lim <leemgs1@gmail.com>
Date: Mon, 7 Sep 2009 20:39:18 +0900
Subject: [PATCH 2/5] Change debuhgfs directory of trace-events-sample.h

Default directory of debug filesystem for ftrace is /sys/kernel/debug/.

       Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
---
 samples/trace_events/trace-events-sample.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index f24ae37..6af3732 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -1,6 +1,6 @@
 /*
  * If TRACE_SYSTEM is defined, that will be the directory created
- * in the ftrace directory under /debugfs/tracing/events/<system>
+ * in the ftrace directory under /sys/kernel/debug/tracing/events/<system>
  *
  * The define_trace.h below will also look for a file name of
  * TRACE_SYSTEM.h where TRACE_SYSTEM is what is defined here.
-- 
1.6.3.1


-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim ( Samsung Electronics )
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://blog.naver.com/invain/
-----------------------------------------------

