Return-Path: <linux-kernel-owner+w=401wt.eu-S1758975AbZBJTV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbZBJTV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbZBJTE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:04:28 -0500
Received: from kroah.org ([198.145.64.141]:33907 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755948AbZBJTEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:04:22 -0500
Date: Tue, 10 Feb 2009 11:01:37 -0800
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
       alan@lxorguk.ukuu.org.uk, Joseph Chan <josephchan@via.com.tw>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 51/53] sata_via: Add VT8261 support
Message-ID: <20090210190137.GZ14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sata_via-add-vt8261-support.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: JosephChan@via.com.tw <JosephChan@via.com.tw>

commit 6813952021a7820a505002de260bda36978671f7 upstream.

Signed-off-by: Joseph Chan <josephchan@via.com.tw>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_via.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -92,6 +92,8 @@ static const struct pci_device_id svia_p
 	{ PCI_VDEVICE(VIA, 0x5372), vt6420 },
 	{ PCI_VDEVICE(VIA, 0x7372), vt6420 },
 	{ PCI_VDEVICE(VIA, 0x5287), vt8251 }, /* 2 sata chnls (Master/Slave) */
+	{ PCI_VDEVICE(VIA, 0x9000), vt8251 },
+	{ PCI_VDEVICE(VIA, 0x9040), vt8251 },
 
 	{ }	/* terminate list */
 };

