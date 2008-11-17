Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbYKQHdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbYKQHdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbYKQHVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:39 -0500
Received: from kroah.org ([198.145.64.141]:38655 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755508AbYKQHVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:33 -0500
Date: Sun, 16 Nov 2008 23:16:43 -0800
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 36/46] USB: unusual_devs entry for Argosy USB mass-storage
	interface
Message-ID: <20081117071643.GK29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-unusual_devs-entry-for-argosy-usb-mass-storage-interface.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 8010e06cc90367b4d3fba3b0ec3ced32360ac890 upstream.

This patch (as1162) adds an unusual_devs entry for Argosy's USB-IDE
interface.  This fixes Bugzilla #11843.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Luciano Rocha <luciano@eurotux.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1251,6 +1251,13 @@ UNUSUAL_DEV( 0x0839, 0x000a, 0x0001, 0x0
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_INQUIRY),
 
+/* Reported by Luciano Rocha <luciano@eurotux.com> */
+UNUSUAL_DEV( 0x0840, 0x0082, 0x0001, 0x0001,
+		"Argosy",
+		"Storage",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY),
+
 /* Entry and supporting patch by Theodore Kilgore <kilgota@auburn.edu>.
  * Flag will support Bulk devices which use a standards-violating 32-byte
  * Command Block Wrapper. Here, the "DC2MEGA" cameras (several brands) with

-- 
