Return-Path: <linux-kernel-owner+w=401wt.eu-S1759086AbYLKTdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbYLKTdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757728AbYLKTSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:47 -0500
Received: from kroah.org ([198.145.64.141]:56274 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757716AbYLKTSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:45 -0500
Date: Thu, 11 Dec 2008 11:15:06 -0800
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
Subject: [patch 42/83] USB: usb-storage: unusual_devs entry for Nikon D2H
Message-ID: <20081211191506.GP5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="usb-usb-storage-unusual_devs-entry-for-nikon-d2h.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tobias Kunze Briseño <t@fictive.com>,

commit 621b239d75b790ac66854d46b094874f69e6776e upstream

This patch adds an unusual_devs entry for the Nikon D2H camera.

From: Tobias Kunze Briseño <t@fictive.com>,
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -389,6 +389,13 @@ UNUSUAL_DEV(  0x04b0, 0x0401, 0x0200, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY),
 
+/* Reported by Tobias Kunze Briseno <t-linux@fictive.com> */
+UNUSUAL_DEV(  0x04b0, 0x0403, 0x0200, 0x0200,
+		"NIKON",
+		"NIKON DSC D2H",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY),
+
 /* Reported by Milinevsky Dmitry <niam.niam@gmail.com> */
 UNUSUAL_DEV(  0x04b0, 0x0409, 0x0100, 0x0100,
 		"NIKON",

