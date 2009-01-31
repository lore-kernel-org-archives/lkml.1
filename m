Return-Path: <linux-kernel-owner+w=401wt.eu-S1762501AbZAaDLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbZAaDLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757434AbZAaCru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:50 -0500
Received: from kroah.org ([198.145.64.141]:55608 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755016AbZAaCrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:42 -0500
Date: Fri, 30 Jan 2009 18:44:46 -0800
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
       alan@lxorguk.ukuu.org.uk, Joerg Schirottke <master@kanotix.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 35/43] ALSA: hda - Add quirk for HP DV6700 laptop
Message-ID: <20090131024446.GJ12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-add-quirk-for-hp-dv6700-laptop.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Schirottke <master@kanotix.com>

commit aa9d823bb347fb66cb07f98c686be8bb85cb6a74 upstream.

Added the matching model=laptop for HP DV6700 laptop.

Signed-off-by: Joerg Schirottke <master@kanotix.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1470,6 +1470,7 @@ static struct snd_pci_quirk cxt5047_cfg_
 	SND_PCI_QUIRK(0x103c, 0x30a5, "HP DV5200T/DV8000T", CXT5047_LAPTOP_HP),
 	SND_PCI_QUIRK(0x103c, 0x30b2, "HP DV2000T/DV3000T", CXT5047_LAPTOP),
 	SND_PCI_QUIRK(0x103c, 0x30b5, "HP DV2000Z", CXT5047_LAPTOP),
+	SND_PCI_QUIRK(0x103c, 0x30cf, "HP DV6700", CXT5047_LAPTOP),
 	SND_PCI_QUIRK(0x1179, 0xff31, "Toshiba P100", CXT5047_LAPTOP_EAPD),
 	{}
 };

