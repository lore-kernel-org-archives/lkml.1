Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbYLKTZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbYLKTZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbYLKTS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:27 -0500
Received: from kroah.org ([198.145.64.141]:55993 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757376AbYLKTSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:17 -0500
Date: Thu, 11 Dec 2008 11:14:17 -0800
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
       alan@lxorguk.ukuu.org.uk, Stefan Bader <stefan.bader@canonical.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 22/83] Input: i8042 - add Blue FB5601 to noloop exception
	table
Message-ID: <20081211191417.GV5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-i8042-add-blue-fb5601-to-noloop-exception-table.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Bader <stefan.bader@canonical.com>

commit 2c6f2cb83b239b7d45da9246cafd27ee615ee35b upstream.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/serio/i8042-x86ia64io.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -135,6 +135,14 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_PRODUCT_VERSION, "5a"),
 		},
 	},
+	{
+		.ident = "Blue FB5601",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "blue"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "FB5601"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "M606"),
+		},
+	},
 	{ }
 };
 

