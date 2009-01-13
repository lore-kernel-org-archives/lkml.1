Return-Path: <linux-kernel-owner+w=401wt.eu-S1758440AbZAMB3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440AbZAMB3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757226AbZAMB24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:28:56 -0500
Received: from kroah.org ([198.145.64.141]:35891 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757073AbZAMB2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:28:54 -0500
Date: Mon, 12 Jan 2009 17:26:51 -0800
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
Subject: [patch 02/21] usb-storage: update unusual_devs entry for Nokia 5310
Message-ID: <20090113012651.GC4512@kroah.com>
References: <20090113012006.063755472@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-storage-update-unusual_devs-entry-for-nokia-5310.patch"
In-Reply-To: <20090113012633.GA4512@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit a4b188095912eee83d065f000dfe06f25919750b upstream.

This patch (as1179) updates the unusual_devs entry for Nokia's 5310
phone to include a more recent firmware revision.

This fixes Bugzilla #12099.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Robson Roberto Souza Peixoto <robsonpeixoto@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -168,7 +168,7 @@ UNUSUAL_DEV(  0x0421, 0x005d, 0x0001, 0x
 		US_FL_FIX_CAPACITY ),
 
 /* Patch for Nokia 5310 capacity */
-UNUSUAL_DEV(  0x0421, 0x006a, 0x0000, 0x0591,
+UNUSUAL_DEV(  0x0421, 0x006a, 0x0000, 0x0701,
 		"Nokia",
 		"5310",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,

