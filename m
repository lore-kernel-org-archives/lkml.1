Return-Path: <linux-kernel-owner+w=401wt.eu-S1762377AbZAaDLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762377AbZAaDLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757412AbZAaCrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:49 -0500
Received: from kroah.org ([198.145.64.141]:55583 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757257AbZAaCrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:41 -0500
Date: Fri, 30 Jan 2009 18:44:44 -0800
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
Subject: [patch 34/43] ALSA: hda - add another MacBook Pro 4, 1 subsystem ID
Message-ID: <20090131024444.GI12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-add-another-macbook-pro-4-1-subsystem-id.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luke Yelavich <themuso@ubuntu.com>

commit 2a88464ceb1bda2571f88902fd8068a6168e3f7b upstream.

Add another MacBook Pro 4,1 SSID (106b:3800). It seems that latter revisions,
(at least mine), have different IDs to earlier revisions.

Signed-off-by: Luke Yelavich <themuso@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6780,6 +6780,7 @@ static int patch_alc882(struct hda_codec
 		case 0x106b00a4: /* MacbookPro4,1 */
 		case 0x106b2c00: /* Macbook Pro rev3 */
 		case 0x106b3600: /* Macbook 3.1 */
+		case 0x106b3800: /* MacbookPro4,1 - latter revision */
 			board_config = ALC885_MBP3;
 			break;
 		default:

