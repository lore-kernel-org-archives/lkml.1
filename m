Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbZAOWrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbZAOWrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934119AbZAOWEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:04:05 -0500
Received: from kroah.org ([198.145.64.141]:39111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934033AbZAOWDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:03:54 -0500
Date: Thu, 15 Jan 2009 14:01:55 -0800
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
       alan@lxorguk.ukuu.org.uk, Oliver Neukum <oneukum@suse.de>,
       Phil Dibowitz <phil@ipom.com>
Subject: [patch 77/85] USB: storage: extend unusual range for 067b:3507
Message-ID: <20090115220155.GZ17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-storage-extend-unusual-range-for-067b-3507.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit b16363991414a6025beb7269f9c1dd294f9b241f upstream.

This device has been released in a new revision which is still buggy.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Phil Dibowitz <phil@ipom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1040,7 +1040,7 @@ UNUSUAL_DEV( 0x067b, 0x2507, 0x0100, 0x0
 		US_FL_FIX_CAPACITY | US_FL_GO_SLOW ),
 
 /* Reported by Alex Butcher <alex.butcher@assursys.co.uk> */
-UNUSUAL_DEV( 0x067b, 0x3507, 0x0001, 0x0001,
+UNUSUAL_DEV( 0x067b, 0x3507, 0x0001, 0x0101,
 		"Prolific Technology Inc.",
 		"ATAPI-6 Bridge Controller",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,

