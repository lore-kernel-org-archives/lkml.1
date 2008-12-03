Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbYLCTzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbYLCTzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbYLCTuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:22 -0500
Received: from kroah.org ([198.145.64.141]:59509 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754471AbYLCTuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:13 -0500
Date: Wed, 3 Dec 2008 11:48:40 -0800
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
       alan@lxorguk.ukuu.org.uk, Jarkko Nikula <jarkko.nikula@nokia.com>,
       David Brownell <david-b@pacbell.net>
Subject: [patch 012/104] gpiolib: extend gpio label column width in debugfs
	file
Message-ID: <20081203194840.GM8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="gpiolib-extend-gpio-label-column-width-in-debugfs-file.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jarkko Nikula <jarkko.nikula@nokia.com>

commit 6e8ba729b6332f2a75572e02480936d2b51665aa upstream.

There are already various drivers having bigger label than 12 bytes.  Most
of them fit well under 20 bytes but make column width exact so that
oversized labels don't mess up output alignment.

Signed-off-by: Jarkko Nikula <jarkko.nikula@nokia.com>
Acked-by: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpio/gpiolib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1049,7 +1049,7 @@ static void gpiolib_dbg_show(struct seq_
 			continue;
 
 		is_out = test_bit(FLAG_IS_OUT, &gdesc->flags);
-		seq_printf(s, " gpio-%-3d (%-12s) %s %s",
+		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s",
 			gpio, gdesc->label,
 			is_out ? "out" : "in ",
 			chip->get

