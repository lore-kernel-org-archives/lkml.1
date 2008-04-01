Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbYDAM50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbYDAM50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 08:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYDAM5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 08:57:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59161 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbYDAM5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 08:57:18 -0400
Date: Tue, 1 Apr 2008 14:57:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>, marcel@holtmann.org,
       maxk@qualcomm.com
Subject: hci_usb: do not initialize static variables to 0
Message-ID: <20080401125752.GA13779@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hci_usb: do not initialize static variables to 0.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 3bd38b1d2beb30823cb19d8757ee3cd820b49e31
tree d1a0562090a5941ab5ef7a3134213667b23cd089
parent 45877d60f059a6a98edb541092eaaabfc93e4efc
author Pavel <pavel@amd.ucw.cz> Tue, 01 Apr 2008 14:57:03 +0200
committer Pavel <pavel@amd.ucw.cz> Tue, 01 Apr 2008 14:57:03 +0200

 drivers/bluetooth/hci_usb.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/bluetooth/hci_usb.c b/drivers/bluetooth/hci_usb.c
index 8b884f8..99a714a 100644
--- a/drivers/bluetooth/hci_usb.c
+++ b/drivers/bluetooth/hci_usb.c
@@ -62,13 +62,13 @@ #undef  URB_ZERO_PACKET
 #define URB_ZERO_PACKET 0
 #endif
 
-static int ignore = 0;
-static int ignore_dga = 0;
-static int ignore_csr = 0;
-static int ignore_sniffer = 0;
-static int disable_scofix = 0;
-static int force_scofix = 0;
-static int reset = 0;
+static int ignore;
+static int ignore_dga;
+static int ignore_csr;
+static int ignore_sniffer;
+static int disable_scofix;
+static int force_scofix;
+static int reset;
 
 #ifdef CONFIG_BT_HCIUSB_SCO
 static int isoc = 2;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
