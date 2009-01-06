Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbZAFJNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbZAFJNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbZAFJNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:13:23 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56797 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbZAFJNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:13:22 -0500
Date: Tue, 6 Jan 2009 10:15:27 +0100
From: Pavel Machek <pavel@suse.cz>
To: jikos@suse.cz, kernel list <linux-kernel@vger.kernel.org>
Subject: HID_DEBUG make defaults consistent
Message-ID: <20090106091526.GA13640@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make defaults consistent with help text suggestions for HID_DEBUG.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 1555e350e30ca0cf46946f3aad62d07047444003
tree f3e8bbaa6b81e7a9f7d8181d2caf85ff49bffa44
parent 4259881431279f13bf6c5ca19b0a0ac9293ec22b
author Pavel <pavel@amd.ucw.cz> Tue, 06 Jan 2009 10:14:55 +0100
committer Pavel <pavel@amd.ucw.cz> Tue, 06 Jan 2009 10:14:55 +0100

 drivers/hid/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index b4fd8ca..9c41d37 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -29,11 +29,11 @@ config HID
 
 	  For docs and specs, see http://www.usb.org/developers/hidpage/
 
-	  If unsure, say Y
+	  If unsure, say Y.
 
 config HID_DEBUG
 	bool "HID debugging support"
-	default y if !EMBEDDED
+	default y 
 	depends on HID
 	---help---
 	This option lets the HID layer output diagnostics about its internal
@@ -44,7 +44,7 @@ config HID_DEBUG
 	This feature is useful for those who are either debugging the HID parser
 	or any HID hardware device.
 
-	If unsure, say N
+	If unsure, say Y.
 
 config HIDRAW
 	bool "/dev/hidraw raw HID device support"

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
