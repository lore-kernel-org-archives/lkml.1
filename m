Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbZLGAOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbZLGAOh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758658AbZLGAOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:14:34 -0500
Received: from kroah.org ([198.145.64.141]:34716 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934398AbZLGAOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:14:11 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:07:01 2009
Message-Id: <20091207000700.872612815@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Feuerer <peter@piie.net>, Andreas Mohr <andi@lisas.de>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Len Brown <len.brown@intel.com>
Subject: [116/119] acerhdf: additional BIOS versions
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=acerhdf-additional-bios-versions.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Peter Feuerer <peter@piie.net>

commit f944915187f53810130eb1c56985e27e3cbe4a6d upstream.

Added BIOS versions:
Acer: AOA110-v0.3307, AOA150-v0.3301, AOA150-v0.3307
Packard Bell: AOA150-v0.3105

Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Borislav Petkov <petkovbb@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/acerhdf.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -139,13 +139,16 @@ static const struct bios_settings_t bios
 	{"Acer", "AOA110", "v0.3301", 0x55, 0x58, {0xaf, 0x00} },
 	{"Acer", "AOA110", "v0.3304", 0x55, 0x58, {0xaf, 0x00} },
 	{"Acer", "AOA110", "v0.3305", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "AOA110", "v0.3307", 0x55, 0x58, {0xaf, 0x00} },
 	{"Acer", "AOA110", "v0.3308", 0x55, 0x58, {0x21, 0x00} },
 	{"Acer", "AOA110", "v0.3309", 0x55, 0x58, {0x21, 0x00} },
 	{"Acer", "AOA110", "v0.3310", 0x55, 0x58, {0x21, 0x00} },
 	/* AOA150 */
 	{"Acer", "AOA150", "v0.3114", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3301", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3304", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3305", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3307", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3308", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3309", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x00} },
@@ -154,6 +157,7 @@ static const struct bios_settings_t bios
 	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x00} },
 	{"Packard Bell", "DOA150", "v0.3104", 0x55, 0x58, {0x21, 0x00} },
 	{"Packard Bell", "AOA110", "v0.3105", 0x55, 0x58, {0x21, 0x00} },
+	{"Packard Bell", "AOA150", "v0.3105", 0x55, 0x58, {0x20, 0x00} },
 	/* pewpew-terminator */
 	{"", "", "", 0, 0, {0, 0} }
 };


