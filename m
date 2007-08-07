Return-Path: <linux-kernel-owner+w=401wt.eu-S966510AbXHGVbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966510AbXHGVbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965273AbXHGU6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:58:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37683 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965270AbXHGU6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:58:36 -0400
Date: Tue, 7 Aug 2007 13:49:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, gmurray@webwayone.co.uk, jirislaby@gmail.com
Subject: [2.6.22.2 review 83/84] sx: switch subven and subid values
Message-ID: <20070807204943.GG23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sx-switch-subven-and-subid-values.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jiri Slaby <jirislaby@gmail.com>

sx.c is failing to locate Graham's card.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Graham Murray <gmurray@webwayone.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/sx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -2721,9 +2721,9 @@ static void __devexit sx_pci_remove(stru
    its because the standard requires it. So check for SUBVENDOR_ID. */
 static struct pci_device_id sx_pci_tbl[] = {
 	{ PCI_VENDOR_ID_SPECIALIX, PCI_DEVICE_ID_SPECIALIX_SX_XIO_IO8,
-		.subvendor = 0x0200,.subdevice = PCI_ANY_ID },
+		.subvendor = PCI_ANY_ID, .subdevice = 0x0200 },
 	{ PCI_VENDOR_ID_SPECIALIX, PCI_DEVICE_ID_SPECIALIX_SX_XIO_IO8,
-		.subvendor = 0x0300,.subdevice = PCI_ANY_ID },
+		.subvendor = PCI_ANY_ID, .subdevice = 0x0300 },
 	{ 0 }
 };
 

-- 
