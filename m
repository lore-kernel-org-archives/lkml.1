Return-Path: <linux-kernel-owner+w=401wt.eu-S1762867AbYHDU0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762867AbYHDU0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763142AbYHDUZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:25:16 -0400
Received: from ns1.suse.de ([195.135.220.2]:48830 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763044AbYHDUZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:25:15 -0400
Date: Mon, 4 Aug 2008 13:15:14 -0700
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
Subject: [patch 14/33] Input: i8042 - add Fujitsu-Siemens Amilo Pro 2010 to
	nomux list
Message-ID: <20080804201514.GO1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-i8042-add-fujitsu-siemens-amilo-pro-2010-to-nomux-list.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 3f79b1e94002791a42837a46b5817e87a0ac0873 upstream

Reported-by: Hans Aschauer <Hans.Aschauer@web.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -200,6 +200,13 @@ static struct dmi_system_id __initdata i
 		},
 	},
 	{
+		.ident = "Fujitsu-Siemens Amilo Pro 2010",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pro V2010"),
+		},
+	},
+	{
 		/*
 		 * No data is coming from the touchscreen unless KBC
 		 * is in legacy mode.

-- 
