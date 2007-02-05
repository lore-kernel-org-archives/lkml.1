Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbXBEKG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbXBEKG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 05:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbXBEKG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 05:06:27 -0500
Received: from serv04.lahn.de ([213.239.197.57]:51430 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbXBEKG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 05:06:26 -0500
Date: Mon, 5 Feb 2007 11:05:29 +0100
From: Michael Leun <ml@newton.leun.net>
To: mitr@volny.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wistron button support for fujitsu-siemens Amilo D88x0
Message-ID: <20070205110529.0e4ae6c0@xenia.leun.net>
In-Reply-To: <20070205103521.0f20779d@xenia.leun.net>
References: <20070205103521.0f20779d@xenia.leun.net>
Organization: Not Organized
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007 10:35:21 +0100
Michael Leun <ml@newton.leun.net> wrote:

> Hello,
> 
> works just fine for me on a Amilo D8820.
> 

Posted old version of patch...

--- linux-2.6.20/drivers/input/misc/wistron_btns.c.orig
2007-02-04 19:44:54.000000000 +0100 +++
linux-2.6.20/drivers/input/misc/wistron_btns.c	2007-02-05
10:05:47.000000000 +0100 @@ -335,6 +335,17 @@ { KE_END,  0 },
 };
 
+static struct key_entry keymap_fs_amilo_d88x0[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x08, KEY_MUTE },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x13, KEY_PROG3 },
+	{ KE_END, 0 }
+};
+
 /*
  * If your machine is not here (which is currently rather likely),
please send
  * a list of buttons and their key codes (reported when loading this
module @@ -413,6 +424,15 @@
 		},
 		.driver_data = keymap_wistron_ms2111
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Fujitsu Siemens Amilo D88x0",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO D"),
+		},
+		.driver_data = keymap_fs_amilo_d88x0
+	},
 	{ NULL, }
 };
 

 


-- 
MfG,

Michael Leun

