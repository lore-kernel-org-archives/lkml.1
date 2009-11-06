Return-Path: <linux-kernel-owner+w=401wt.eu-S932822AbZKFWXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822AbZKFWXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932743AbZKFWXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:51 -0500
Received: from kroah.org ([198.145.64.141]:57241 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932613AbZKFWXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:48 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:52 2009
Message-Id: <20091106221552.566130941@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joseph Chan <josephchan@via.com.tw>, Jeff Garzik <jgarzik@redhat.com>
Subject: [98/99] sata_via: Remove redundant device ID for VIA VT8261
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=sata_via-remove-redundant-device-id-for-via-vt8261.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: JosephChan@via.com.tw <JosephChan@via.com.tw>

commit f38e35b43f2924b3b4e51147b7193f32e9276db4 upstream.

Just remove redundant device ID for VIA VT8261.
The device ID 0x9000 and 0x9040 are redundant (for VT8261).
The 0x9040 is reserved for other usage.

Signed-off-by: Joseph Chan <josephchan@via.com.tw>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_via.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -93,7 +93,6 @@ static const struct pci_device_id svia_p
 	{ PCI_VDEVICE(VIA, 0x7372), vt6420 },
 	{ PCI_VDEVICE(VIA, 0x5287), vt8251 }, /* 2 sata chnls (Master/Slave) */
 	{ PCI_VDEVICE(VIA, 0x9000), vt8251 },
-	{ PCI_VDEVICE(VIA, 0x9040), vt8251 },
 
 	{ }	/* terminate list */
 };


