Return-Path: <linux-kernel-owner+w=401wt.eu-S1762760AbXLMG7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762760AbXLMG7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:59:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758794AbXLMGzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:55:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55056 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761175AbXLMGzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:55:51 -0500
Date: Wed, 12 Dec 2007 22:51:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 09/60] Input: ALPS - add signature for ThinkPad R61
Message-ID: <20071213065127.GJ6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-alps-add-signature-for-thinkpad-r61.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

changeset f493018ebc3f94d64e12bc848db0906700bf73a2 in mainline.

Input: ALPS - add signature for ThinkPad R61

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/mouse/alps.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -48,6 +48,7 @@ static const struct alps_model_info alps
 	{ { 0x63, 0x02, 0x50 },	0xef, 0xef, ALPS_FW_BK_1 },		/* NEC Versa L320 */
 	{ { 0x63, 0x02, 0x64 },	0xf8, 0xf8, 0 },
 	{ { 0x63, 0x03, 0xc8 }, 0xf8, 0xf8, ALPS_PASS },		/* Dell Latitude D800 */
+	{ { 0x73, 0x00, 0x0a },	0xf8, 0xf8, ALPS_DUALPOINT },		/* ThinkPad R61 8918-5QG */
 	{ { 0x73, 0x02, 0x0a },	0xf8, 0xf8, 0 },
 	{ { 0x73, 0x02, 0x14 },	0xf8, 0xf8, ALPS_FW_BK_2 },		/* Ahtec Laptop */
 	{ { 0x20, 0x02, 0x0e },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT }, /* XXX */

-- 
