Return-Path: <linux-kernel-owner+w=401wt.eu-S1760097AbYHRSwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097AbYHRSwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759747AbYHRSvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:51:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35011 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759738AbYHRSvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:51:20 -0400
Date: Mon, 18 Aug 2008 11:43:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes@sipsolutions.net>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 16/60] USB: usb-storage: quirk around v1.11 firmware on
	Nikon D4
Message-ID: <20080818184300.GQ29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-usb-storage-quirk-around-v1.11-firmware-on-nikon-d4.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dave Jones <davej@redhat.com>

commit b9a097f26e55968cbc52e30a4a2e73d32d7604ce upstream

usb-storage: quirk around v1.11 firmware on Nikon D40

https://bugzilla.redhat.com/show_bug.cgi?id=454028
Just as in earlier firmware versions, we need to perform this
quirk for the latest version too.

Speculatively do the entry for the D80 too, as they seem to
have the same firmware problems historically.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -358,14 +358,14 @@ UNUSUAL_DEV(  0x04b0, 0x040f, 0x0100, 0x
 		US_FL_FIX_CAPACITY),
 
 /* Reported by Emil Larsson <emil@swip.net> */
-UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0110,
+UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0111,
 		"NIKON",
 		"NIKON DSC D80",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY),
 
 /* Reported by Ortwin Glueck <odi@odi.ch> */
-UNUSUAL_DEV(  0x04b0, 0x0413, 0x0110, 0x0110,
+UNUSUAL_DEV(  0x04b0, 0x0413, 0x0110, 0x0111,
 		"NIKON",
 		"NIKON DSC D40",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,

-- 
