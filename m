Return-Path: <linux-kernel-owner+w=401wt.eu-S1760219AbYLKTbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbYLKTbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757685AbYLKTSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:43 -0500
Received: from kroah.org ([198.145.64.141]:56211 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757658AbYLKTSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:39 -0500
Date: Thu, 11 Dec 2008 11:14:57 -0800
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
       alan@lxorguk.ukuu.org.uk,
       Ricky Wong Yung Fei <evilbladewarrior@gmail.com>
Subject: [patch 38/83] USB: unusual devs patch for Nokia 7610 Supernova
Message-ID: <20081211191457.GL5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-unusual-devs-patch-for-nokia-7610-supernova.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ricky Wong <evilbladewarrior@gmail.com>

commit ed4103b3fcf38985995e732dab6c3e2b9693f6cb upstream.

Additional sectors were reported by the Nokia 7610 Supernova phone in
usb storage mode. The following patch rectifies the aforementioned
problem.

Signed-off-by: Ricky Wong Yung Fei <evilbladewarrior@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/storage/unusual_devs.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -253,6 +253,14 @@ UNUSUAL_DEV(  0x0421, 0x006a, 0x0000, 0x
 	US_SC_DEVICE, US_PR_DEVICE, NULL,
 	US_FL_FIX_CAPACITY ),
 
+/* Submitted by Ricky Wong Yung Fei <evilbladewarrior@gmail.com> */
+/* Nokia 7610 Supernova - Too many sectors reported in usb storage mode */
+UNUSUAL_DEV(  0x0421, 0x00f5, 0x0000, 0x0470,
+	"Nokia",
+	"7610 Supernova",
+	US_SC_DEVICE, US_PR_DEVICE, NULL,
+	US_FL_FIX_CAPACITY ),
+
 /* Reported by Olaf Hering <olh@suse.de> from novell bug #105878 */
 UNUSUAL_DEV(  0x0424, 0x0fdc, 0x0210, 0x0210,
 		"SMSC",

