Return-Path: <linux-kernel-owner+w=401wt.eu-S933602AbZIPWnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602AbZIPWnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760480AbZIPWnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:43:04 -0400
Received: from kroah.org ([198.145.64.141]:55459 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933636AbZIPWk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:40:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:19 2009
Message-Id: <20090916223719.861500408@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 44/45] PCI: Unhide the SMBus on the Compaq Evo D510 USDT
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=pci-unhide-the-smbus-on-the-compaq-evo-d510-usdt.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit 6b5096e4d4496e185cd1ada5d1b8e1d941c805ed upstream.

One more form factor for Compaq Evo D510, which needs the same quirk
as the other form factors. Apparently there's no hardware monitoring
chip on that one, but SPD EEPROMs, so it's still worth unhiding the
SMBus.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Nuzhna Pomoshch <nuzhna_pomoshch@yahoo.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1201,6 +1201,7 @@ static void __init asus_hides_smbus_host
 			switch(dev->subsystem_device) {
 			case 0x00b8: /* Compaq Evo D510 CMT */
 			case 0x00b9: /* Compaq Evo D510 SFF */
+			case 0x00ba: /* Compaq Evo D510 USDT */
 				/* Motherboard doesn't have Host bridge
 				 * subvendor/subdevice IDs and on-board VGA
 				 * controller is disabled if an AGP card is


