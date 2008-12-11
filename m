Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbYLKTcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbYLKTcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757703AbYLKTSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:44 -0500
Received: from kroah.org ([198.145.64.141]:56237 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757679AbYLKTSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:42 -0500
Date: Thu, 11 Dec 2008 11:15:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 40/83] USB: storage: update unusual_devs entries for Nokia
	5300 and 5310
Message-ID: <20081211191501.GN5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-storage-update-unusual_devs-entries-for-nokia-5300-and-5310.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 589afd3bec907f02c133d7b8185b8af534f14a8e upstream

This patch (as1168) updates the unusual_devs entry for the Nokia 5300.
According to Jorge Lucangeli Obes <t4m5yn@gmail.com>, some existing
models have a revision number lower than the lower limit of the
current entry.

The patch also moves the entry for the Nokia 5310 to its correct place
in the file.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/storage/unusual_devs.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -167,6 +167,13 @@ UNUSUAL_DEV(  0x0421, 0x005d, 0x0001, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
 
+/* Patch for Nokia 5310 capacity */
+UNUSUAL_DEV(  0x0421, 0x006a, 0x0000, 0x0591,
+		"Nokia",
+		"5310",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY ),
+
 /* Reported by Mario Rettig <mariorettig@web.de> */
 UNUSUAL_DEV(  0x0421, 0x042e, 0x0100, 0x0100,
 		"Nokia",
@@ -233,7 +240,7 @@ UNUSUAL_DEV(  0x0421, 0x0495, 0x0370, 0x
 		US_FL_MAX_SECTORS_64 ),
 
 /* Reported by Cedric Godin <cedric@belbone.be> */
-UNUSUAL_DEV(  0x0421, 0x04b9, 0x0551, 0x0551,
+UNUSUAL_DEV(  0x0421, 0x04b9, 0x0500, 0x0551,
 		"Nokia",
 		"5300",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,

