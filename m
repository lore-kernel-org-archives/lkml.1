Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbYLKTZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbYLKTZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbYLKTS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:26 -0500
Received: from kroah.org ([198.145.64.141]:55982 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757367AbYLKTSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:16 -0500
Date: Thu, 11 Dec 2008 11:14:15 -0800
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
       alan@lxorguk.ukuu.org.uk, Colin B Macdonald <cbm@m.fsf.org>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 21/83] Input: i8042 - add Thinkpad R31 to nomux list
Message-ID: <20081211191415.GU5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-i8042-add-thinkpad-r31-to-nomux-list.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Colin B Macdonald <cbm@m.fsf.org>

commit 5bd8a05e937b3ab88cd7ea569e32738f36c42bd0 upstream.

Thinkpad R31 needs i8042 nomux quirk.  Stops jittery jumping mouse
and random keyboard input. Fixes kernel bug #11723.  Cherry picked
from Ubuntu who have sometimes (on-again-off-again) had a fix in
their patched kernels.

Signed-off-by: Colin B Macdonald <cbm@m.fsf.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -322,6 +322,13 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_PRODUCT_NAME, "N34AS6"),
 		},
 	},
+	{
+		.ident = "IBM 2656",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "2656"),
+		},
+	},
 	{ }
 };
 

