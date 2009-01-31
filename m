Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbZAaDEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbZAaDEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbZAaCrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:32 -0500
Received: from kroah.org ([198.145.64.141]:55311 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756719AbZAaCrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:22 -0500
Date: Fri, 30 Jan 2009 18:42:44 -0800
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
       alan@lxorguk.ukuu.org.uk, Oliver Neukum <oneukum@suse.de>
Subject: [patch 15/43] USB: storage: add unusual devs entry
Message-ID: <20090131024244.GP12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-storage-add-unusual-devs-entry.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit b90de8aea36ae6fe8050a6e91b031369c4f251b2 upstream.

This adds an unusual devs entry for 2116:0320

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1970,6 +1970,12 @@ UNUSUAL_DEV(  0x19d2, 0x2000, 0x0000, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_IGNORE_DEVICE),
 
+UNUSUAL_DEV( 0x2116, 0x0320, 0x0001, 0x0001,
+		"ST",
+		"2A",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY),
+
 /* patch submitted by Davide Perini <perini.davide@dpsoftware.org>
  * and Renato Perini <rperini@email.it>
  */

