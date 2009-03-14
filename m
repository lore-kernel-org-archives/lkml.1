Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbZCNA2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbZCNA2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbZCNASw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:18:52 -0400
Received: from kroah.org ([198.145.64.141]:46914 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753199AbZCNASu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:43 2009
Message-Id: <20090314000743.496802582@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:38 -0700
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
       alan@lxorguk.ukuu.org.uk, Luke Yelavich <themuso@ubuntu.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 30/96] ALSA: hda - add another MacBook Pro 3,1 SSID
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=alsa-hda-add-another-macbook-pro-3-1-ssid.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luke Yelavich <themuso@ubuntu.com>

commit 2d4663816064fabb68935f920bbd7ccdc7f9392d upstream.

Reference: Ubuntu bug #33245
    https://bugs.launchpad.net/bugs/332456

Signed-off-by: Luke Yelavich <themuso@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6630,6 +6630,7 @@ static int patch_alc882(struct hda_codec
 		case 0x106b2800: /* AppleTV */
 			board_config = ALC885_IMAC24;
 			break;
+		case 0x106b00a0: /* MacBookPro3,1 - Another revision */
 		case 0x106b00a1: /* Macbook (might be wrong - PCI SSID?) */
 		case 0x106b2c00: /* Macbook Pro rev3 */
 		case 0x106b3600: /* Macbook 3.1 */


