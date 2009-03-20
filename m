Return-Path: <linux-kernel-owner+w=401wt.eu-S1762947AbZCTXYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762947AbZCTXYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760252AbZCTXOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:14:11 -0400
Received: from kroah.org ([198.145.64.141]:53316 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759401AbZCTXOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:14:03 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:27:13 2009
Message-Id: <20090320222713.848173083@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:26:42 -0700
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
       alan@lxorguk.ukuu.org.uk, Moritz Muehlenhoff <jmm@debian.org>,
       Phil Dibowitz <phil@ipom.com>
Subject: [patch 31/32] USB: Updated unusual-devs entry for USB mass storage on Nokia 6233
References: <20090320222611.872315885@mini.kroah.org>
Content-Disposition: inline; filename=usb-updated-unusual-devs-entry-for-usb-mass-storage-on-nokia-6233.patch
In-Reply-To: <20090320231037.GA2732@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Moritz Muehlenhoff <jmm@debian.org>

commit 716a9c8561d9c50ec454f4fbd39a265892feda2c upstream.

Current firmware revision 5.60 still behaves the same,
so update the quirk up a (non-existing) 99.99 revision.

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=493415

Signed-off-by: Moritz Muehlenhoff <jmm@debian.org>
Tested-by: Jan Heitkoetter <devnull@heitkoetter.net>
Signed-off-by: Phil Dibowitz <phil@ipom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -219,7 +219,7 @@ UNUSUAL_DEV(  0x0421, 0x047c, 0x0370, 0x
 		US_FL_MAX_SECTORS_64 ),
 
 /* Reported by Manuel Osdoba <manuel.osdoba@tu-ilmenau.de> */
-UNUSUAL_DEV( 0x0421, 0x0492, 0x0452, 0x0452,
+UNUSUAL_DEV( 0x0421, 0x0492, 0x0452, 0x9999,
 		"Nokia",
 		"Nokia 6233",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,


