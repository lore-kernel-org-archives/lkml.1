Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZASP4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZASP4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 10:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbZASP43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 10:56:29 -0500
Received: from cantor.suse.de ([195.135.220.2]:56611 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbZASP43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 10:56:29 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] Mark mandatory elevator functions in the biodoc.txt
Date: Mon, 19 Jan 2009 21:23:58 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901192123.58837.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

biodoc.txt mentions that elevator functions marked with * are mandatory, but
no function is marked with *.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---
diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index 3c5434c..5e51217 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -953,14 +953,14 @@ elevator_allow_merge_fn		called whenever the block layer determines
 				results in some sort of conflict internally,
 				this hook allows it to do that.
 
-elevator_dispatch_fn		fills the dispatch queue with ready requests.
+elevator_dispatch_fn*		fills the dispatch queue with ready requests.
 				I/O schedulers are free to postpone requests by
 				not filling the dispatch queue unless @force
 				is non-zero.  Once dispatched, I/O schedulers
 				are not allowed to manipulate the requests -
 				they belong to generic dispatch queue.
 
-elevator_add_req_fn		called to add a new request into the scheduler
+elevator_add_req_fn*		called to add a new request into the scheduler
 
 elevator_queue_empty_fn		returns true if the merge queue is empty.
 				Drivers shouldn't use this, but rather check
@@ -990,7 +990,7 @@ elevator_activate_req_fn	Called when device driver first sees a request.
 elevator_deactivate_req_fn	Called when device driver decides to delay
 				a request by requeueing it.
 
-elevator_init_fn
+elevator_init_fn*
 elevator_exit_fn		Allocate and free any elevator specific storage
 				for a queue.
 

