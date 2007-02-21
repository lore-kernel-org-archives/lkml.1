Return-Path: <linux-kernel-owner+w=401wt.eu-S1751091AbXBUBjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091AbXBUBjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbXBUBiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:38:55 -0500
Received: from ns2.suse.de ([195.135.220.15]:34471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbXBUBiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:38:24 -0500
Date: Tue, 20 Feb 2007 17:36:56 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 04/21] V4L: tveeprom: autodetect LG TAPC G701D as tuner type 37
Message-ID: <20070221013656.GE30227@kroah.com>
References: <20070221012758.925122216@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="V4L-tveeprom-autodetect-LG-TAPC-G701D-as-tuner-type-37.patch"
In-Reply-To: <20070221013619.GA30227@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
Autodetect LG TAPC G701D as tuner type 37, fixing
mis-detected tuners in some Hauppauge tv tuner cards.

Thanks to Adonis Papas, for pointing this out.

(cherry picked from commit 1323fbda1343f50f198bc8bd6d1d59c8b7fc45bf)

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/tveeprom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.19.4.orig/drivers/media/video/tveeprom.c
+++ linux-2.6.19.4/drivers/media/video/tveeprom.c
@@ -184,7 +184,7 @@ hauppauge_tuner[] =
 	{ TUNER_ABSENT,        "Thompson DTT757"},
 	/* 80-89 */
 	{ TUNER_ABSENT,        "Philips FQ1216LME MK3"},
-	{ TUNER_ABSENT,        "LG TAPC G701D"},
+	{ TUNER_LG_PAL_NEW_TAPC, "LG TAPC G701D"},
 	{ TUNER_LG_NTSC_NEW_TAPC, "LG TAPC H791F"},
 	{ TUNER_LG_PAL_NEW_TAPC, "TCL 2002MB 3"},
 	{ TUNER_LG_PAL_NEW_TAPC, "TCL 2002MI 3"},

--
