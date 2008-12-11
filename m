Return-Path: <linux-kernel-owner+w=401wt.eu-S1760283AbYLKTbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbYLKTbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757693AbYLKTSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:43 -0500
Received: from kroah.org ([198.145.64.141]:56224 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757154AbYLKTSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:40 -0500
Date: Thu, 11 Dec 2008 11:14:59 -0800
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
Subject: [patch 39/83] USB: storage: updates unusual_devs entry for the
	Nokia 6300
Message-ID: <20081211191459.GM5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-storage-updates-unusual_devs-entry-for-the-nokia-6300.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 9beba53dc5c330d781ecc0ad8ea081c2d100ff9f upstream

This patch (as1169) modifies the unusual_devs entry for the Nokia
6300.  According to Maciej Gierok <mgierok@gmail.com> and David
McBride <dwm@doc.ic.ac.uk>, the revision limits need to be wider.

This fixes Bugzilla #11768.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/storage/unusual_devs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -240,7 +240,7 @@ UNUSUAL_DEV(  0x0421, 0x04b9, 0x0551, 0x
 		US_FL_FIX_CAPACITY ),
 
 /* Reported by Richard Nauber <RichardNauber@web.de> */
-UNUSUAL_DEV(  0x0421, 0x04fa, 0x0601, 0x0601,
+UNUSUAL_DEV(  0x0421, 0x04fa, 0x0550, 0x0660,
 		"Nokia",
 		"6300",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,

