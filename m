Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbYHDUZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbYHDUZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763063AbYHDUYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:24:52 -0400
Received: from ns2.suse.de ([195.135.220.15]:45731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762960AbYHDUYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:24:51 -0400
Date: Mon, 4 Aug 2008 13:15:12 -0700
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
Subject: [patch 13/33] Input: i8042 - add Fujitsu-Siemens Amilo Pro V2030
	to nomux table
Message-ID: <20080804201512.GN1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-i8042-add-fujitsu-siemens-amilo-pro-v2030-to-nomux-table.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

Commit efd5184646d5d400fc538d093e9a0bec22a75551 upstream

Fujitsu Siemens Amilo Pro V2030 needs nomux table entry, in addition to
already existing entry for V2010 model (note that Fujitsu-Siemens changed
the capitalization in the DMI data for product).

Tested-by: Jiri Mleziva <jmleziva@tiscali.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -193,6 +193,13 @@ static struct dmi_system_id __initdata i
 		},
 	},
 	{
+		.ident = "Fujitsu-Siemens Amilo Pro 2030",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO PRO V2030"),
+		},
+	},
+	{
 		/*
 		 * No data is coming from the touchscreen unless KBC
 		 * is in legacy mode.

-- 
