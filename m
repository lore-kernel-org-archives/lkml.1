Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbZHMTtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbZHMTtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbZHMTsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:48:02 -0400
Received: from kroah.org ([198.145.64.141]:36786 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165AbZHMTsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:48:00 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:39 2009
Message-Id: <20090813194339.036960194@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rogerio Brito <rbrito@ime.usp.br>, Phil Dibowitz <phil@ipom.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Robert Hancock <hancockrwd@gmail.com>
Subject: [patch 22/28] USB: storage: include Prolific Technology USB drive in unusual_devs list
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=usb-storage-include-prolific-technology-usb-drive-in-unusual_devs-list.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rogerio Brito <rbrito@ime.usp.br>

commit c15e3ca1d822abba78c00b1ffc3e7b382a50396e upstream.

Add a quirk entry for the Leading Driver UD-11 usb flash drive.

As Alan Stern told me, the device doesn't deal correctly with the
locking media feature of the device, and this patch incorporates it.

Compiled, tested, working.

Signed-off-by: Rogerio Brito <rbrito@ime.usp.br>
Cc: Phil Dibowitz <phil@ipom.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Robert Hancock <hancockrwd@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -989,6 +989,13 @@ UNUSUAL_DEV( 0x066f, 0x8000, 0x0001, 0x0
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
 
+/* Reported by Rogerio Brito <rbrito@ime.usp.br> */
+UNUSUAL_DEV( 0x067b, 0x2317, 0x0001, 0x001,
+		"Prolific Technology, Inc.",
+		"Mass Storage Device",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_NOT_LOCKABLE ),
+
 /* Reported by Richard -=[]=- <micro_flyer@hotmail.com> */
 /* Change to bcdDeviceMin (0x0100 to 0x0001) reported by
  * Thomas Bartosik <tbartdev@gmx-topmail.de> */


