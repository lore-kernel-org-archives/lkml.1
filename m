Return-Path: <linux-kernel-owner+w=401wt.eu-S1757794AbYLCUP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbYLCUP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYLCTyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:54:40 -0500
Received: from kroah.org ([198.145.64.141]:60398 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755482AbYLCTyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:54:39 -0500
Date: Wed, 3 Dec 2008 11:53:05 -0800
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
       alan@lxorguk.ukuu.org.uk, Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 064/104] firewire: fw-sbp2: another iPod mini quirk entry
Message-ID: <20081203195305.GM8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="firewire-fw-sbp2-another-ipod-mini-quirk-entry.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 031bb27c4bf77c2f60b3f3dea8cce63ef0d1fba9 upstream.

Add another model ID of a broken firmware to prevent early I/O errors
by acesses at the end of the disk.  Reported at linux1394-user,
http://marc.info/?t=122670842900002

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/fw-sbp2.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -365,6 +365,11 @@ static const struct {
 	},
 	/* iPod mini */ {
 		.firmware_revision	= 0x0a2700,
+		.model			= 0x000022,
+		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
+	},
+	/* iPod mini */ {
+		.firmware_revision	= 0x0a2700,
 		.model			= 0x000023,
 		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
 	},

