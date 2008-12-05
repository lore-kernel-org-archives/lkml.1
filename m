Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbYLEKXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbYLEKXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYLEKU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:20:57 -0500
Received: from vps1.tull.net ([66.180.172.116]:47105 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751789AbYLEKUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:20:55 -0500
Mail-From: nobody Fri Dec  5 14:08:02 2008
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH] Fix incorrect use of loose in event.c
To: Nick Andrew <nick@nick-andrew.net>, <trivial@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Nick Andrew <nick@nick-andrew.net>
Date: Fri, 05 Dec 2008 14:08:02 +1100
Message-ID: <20081205030802.32056.24527.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect use of loose in event.c

It should be 'lose', not 'loose'.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/misc/ibmasm/event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/misc/ibmasm/event.c b/drivers/misc/ibmasm/event.c
index fda6a4d..68a0a5b 100644
--- a/drivers/misc/ibmasm/event.c
+++ b/drivers/misc/ibmasm/event.c
@@ -50,7 +50,7 @@ static void wake_up_event_readers(struct service_processor *sp)
  * Store the event in the circular event buffer, wake up any sleeping
  * event readers.
  * There is no reader marker in the buffer, therefore readers are
- * responsible for keeping up with the writer, or they will loose events.
+ * responsible for keeping up with the writer, or they will lose events.
  */
 void ibmasm_receive_event(struct service_processor *sp, void *data, unsigned int data_size)
 {


