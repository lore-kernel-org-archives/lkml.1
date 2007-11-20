Return-Path: <linux-kernel-owner+w=401wt.eu-S1764639AbXKTSiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764639AbXKTSiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760740AbXKTS21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:28:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52106 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762120AbXKTS20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:28:26 -0500
Date: Tue, 20 Nov 2007 10:25:07 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tobias Powalowski <t.powa@gmx.de>
Subject: [patch 28/29] USB: Nikon D40X unusual_devs entry
Message-ID: <20071120182507.GD28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="usb-nikon-d40x-unusual_devs-entry.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Ortwin Glück <odi@odi.ch>

patch d466a9190ff1ceddfee50686e61d63590fc820d9 in mainline.

Not surprisingly the Nikon D40X DSC needs the same quirks as the D40,
but it has a separate ID.
See http://bugs.gentoo.org/show_bug.cgi?id=191431

From: Ortwin Glück <odi@odi.ch>
Cc: Tobias Powalowski <t.powa@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -362,6 +362,13 @@ UNUSUAL_DEV(  0x04b0, 0x0413, 0x0110, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY),
 
+/* Reported by Shan Destromp (shansan@gmail.com) */
+UNUSUAL_DEV(  0x04b0, 0x0417, 0x0100, 0x0100,
+		"NIKON",
+		"NIKON DSC D40X",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY),
+
 /* BENQ DC5330
  * Reported by Manuel Fombuena <mfombuena@ya.com> and
  * Frank Copeland <fjc@thingy.apana.org.au> */

-- 
