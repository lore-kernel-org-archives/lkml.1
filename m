Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbXEDOI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbXEDOI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbXEDOI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:08:27 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:37742 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333AbXEDOI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:08:26 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Fri, 4 May 2007 19:55:55 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org, minyard@acm.org
Subject: [PATCH (trivial)] Fix wrong identifier name in Documentation/kref.txt
Message-ID: <Pine.LNX.4.64.0705041949130.14683@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's another trivial one I've been meaning to send since ... a long 
time back.

Cheers,
Satyam

---

There's a typo / wrong identifier name in Documentation/kref.txt. Fix it.

 	Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

---

diff -ruNp linux-2.6.21.1/Documentation/kref.txt linux-2.6.21.1~patch/Documentation/kref.txt
--- linux-2.6.21.1/Documentation/kref.txt	2007-05-04 19:40:01.000000000 +0530
+++ linux-2.6.21.1~patch/Documentation/kref.txt	2007-05-04 19:41:04.000000000 +0530
@@ -67,7 +67,7 @@ void more_data_handling(void *cb_data)
  	.
  	. do stuff with data here
  	.
-	kref_put(data, data_release);
+	kref_put(&data->refcount, data_release);
  }

  int my_data_handler(void)

