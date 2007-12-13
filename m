Return-Path: <linux-kernel-owner+w=401wt.eu-S1762665AbXLMG6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762665AbXLMG6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761169AbXLMGzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:55:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55042 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761126AbXLMGzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:55:49 -0500
Date: Wed, 12 Dec 2007 22:51:24 -0800
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
       William Pettersson <william.pettersson@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 08/60] Input: ALPS - add support for model found in Dell
	Vostro 1400
Message-ID: <20071213065124.GI6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-alps-add-support-for-model-found-in-dell-vostro-1400.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: William Pettersson <william.pettersson@gmail.com>

changeset dac4ae0daa1be36ab015973ed9e9dc04a2684395 in mainline.

Input: ALPS - add support for model found in Dell Vostro 1400

Signed-off-by: William Pettersson <william.pettersson@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/mouse/alps.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -53,6 +53,7 @@ static const struct alps_model_info alps
 	{ { 0x20, 0x02, 0x0e },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT }, /* XXX */
 	{ { 0x22, 0x02, 0x0a },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT },
 	{ { 0x22, 0x02, 0x14 }, 0xff, 0xff, ALPS_PASS | ALPS_DUALPOINT }, /* Dell Latitude D600 */
+	{ { 0x73, 0x02, 0x50 }, 0xcf, 0xff, ALPS_FW_BK_1 } /* Dell Vostro 1400 */
 };
 
 /*

-- 
