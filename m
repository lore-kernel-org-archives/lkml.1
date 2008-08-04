Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbYHDVtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbYHDVtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765986AbYHDVjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:39:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:54930 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765528AbYHDVjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:39:06 -0400
Date: Mon, 4 Aug 2008 14:30:29 -0700
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
       alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 15/25] Input: i8042 - add Gericom Bellagio to nomux
	blacklist
Message-ID: <20080804213029.GO8014@suse.de>
References: <20080804203506.816201392@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-i8042-add-gericom-bellagio-to-nomux-blacklist.patch"
In-Reply-To: <20080804212725.GA7944@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 5b5b43d0b32ea586036638288c31179f00de5443 upstream

Gericom Bellagio needs to be added to nomux blacklist, otherwise its
touchpad misbehaves.

Reported-by: Roland Kletzing <roland.kletzing@materna.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -303,6 +303,13 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
 		},
 	},
+	{
+		.ident = "Gericom Bellagio",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Gericom"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N34AS6"),
+		},
+	},
 	{ }
 };
 #endif

-- 
