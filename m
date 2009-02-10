Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbZBJTOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbZBJTOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbZBJTD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:59 -0500
Received: from kroah.org ([198.145.64.141]:53963 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755827AbZBJTD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:58 -0500
Date: Tue, 10 Feb 2009 11:00:44 -0800
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
       alan@lxorguk.ukuu.org.uk, Roel Kluin <roel.kluin@gmail.com>,
       Len Brown <len.brown@intel.com>
Subject: [patch 30/53] panasonic-laptop: fix X[ ARRAY_SIZE(X) ]
Message-ID: <20090210190044.GE14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="panasonic-laptop-fix-x.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit 2b190e76def5233c542f6025b4a133b1d4bd1a37 upstream.

Ensure pcc->keymap[ ARRAY_SIZE(pcc->keymap) ] does not occur.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/panasonic-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/panasonic-laptop.c
+++ b/drivers/misc/panasonic-laptop.c
@@ -515,7 +515,7 @@ static void acpi_pcc_generate_keyinput(s
 
 	hkey_num = result & 0xf;
 
-	if (hkey_num < 0 || hkey_num > ARRAY_SIZE(pcc->keymap)) {
+	if (hkey_num < 0 || hkey_num >= ARRAY_SIZE(pcc->keymap)) {
 		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
 				  "hotkey number out of range: %d\n",
 				  hkey_num));

