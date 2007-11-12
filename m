Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbXKLKC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbXKLKC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 05:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbXKLKCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 05:02:22 -0500
Received: from pD9E86146.dip.t-dialin.net ([217.232.97.70]:3219 "EHLO
	xenon.ts.pxnet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755732AbXKLKCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 05:02:21 -0500
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Nov 2007 05:02:21 EST
Subject: [PATCH] USB: power-management.txt - disconnect clarification
From: Tilman Schmidt <tilman@imap.cc>
To: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-Id: <20071112095535.B778111004B@xenon.ts.pxnet.com>
Date: Mon, 12 Nov 2007 10:55:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>

Add a paragraph to Documentation/usb/power-management.txt about the
interaction between suspend and disconnect.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---

--- linux-2.6/Documentation/usb/power-management.txt	2007-10-14 00:41:08.000000000 +0200
+++ linux-2.6.24-rc2-work/Documentation/usb/power-management.txt	2007-11-12 10:27:30.000000000 +0100
@@ -278,6 +278,12 @@
 	(although the interfaces will be in the same altsettings as
 	before the suspend).
 
+If the device is disconnected or powered down while it is suspended,
+the disconnect method will be called instead of the resume or
+reset_resume method.  This will also happen if the system is resumed
+from hibernation, as the device could have been disconnected without
+the system being able to detect it.
+
 The reset_resume method is used by the USB Persist facility (see
 Documentation/usb/persist.txt) and it can also be used under certain
 circumstances when CONFIG_USB_PERSIST is not enabled.  Currently, if a
