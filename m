Return-Path: <linux-kernel-owner+w=401wt.eu-S1759562AbZBKAn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562AbZBKAn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757869AbZBKA2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:48 -0500
Received: from kroah.org ([198.145.64.141]:51540 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756802AbZBKA2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:46 -0500
Date: Tue, 10 Feb 2009 16:25:46 -0800
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
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Denis Joseph Barrow <D.Barow@option.com>,
       Jeff Garzik <jgarzik@redhat.com>, Frank Seidel <fseidel@suse.de>
Subject: [patch 44/56] hso: rfkill type should be WWAN
Message-ID: <20090211002546.GS14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hso-rfkill-type-should-be-wwan.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>

commit db053c6b447d083f3c63e5540b70a3e521b468ca upstream.

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: Denis Joseph Barrow <D.Barow@option.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Frank Seidel <fseidel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/hso.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2047,7 +2047,7 @@ static void hso_create_rfkill(struct hso
 	char *rfkn;
 
 	hso_net->rfkill = rfkill_allocate(&interface_to_usbdev(interface)->dev,
-				 RFKILL_TYPE_WLAN);
+				 RFKILL_TYPE_WWAN);
 	if (!hso_net->rfkill) {
 		dev_err(dev, "%s - Out of memory", __func__);
 		return;

