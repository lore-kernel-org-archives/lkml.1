Return-Path: <linux-kernel-owner+w=401wt.eu-S1751529AbZHMKTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbZHMKTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZHMKTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:19:40 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.36]:52506 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbZHMKTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:19:40 -0400
Date: Thu, 13 Aug 2009 12:19:37 +0200
From: Peter Feuerer <peter@piie.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>,
       lenb@kernel.org, Andreas Mohr <andi@lisas.de>,
       Peter Feuerer <peter@piie.net>
Subject: Re: [PATCH 2/2] acerhdf: additional BIOS versions
Message-Id: <20090813121937.3d485e70.peter@piie.net>
In-Reply-To: <20090813121722.48988dfc.peter@piie.net>
References: <20090813121722.48988dfc.peter@piie.net>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: 650477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added BIOS versions:
Acer: AOA110-v0.3307, AOA150-v0.3301, AOA150-v0.3307
Pckard Bell: AOA150-v0.3105

Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Borislav Petkov <petkovbb@googlemail.com>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/platform/x86/acerhdf.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 8ff5639..e0d4f0b 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -139,13 +139,16 @@ static const struct bios_settings_t bios_tbl[] = {
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
@@ -154,6 +157,7 @@ static const struct bios_settings_t bios_tbl[] = {
 	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x00} },
 	{"Packard Bell", "DOA150", "v0.3104", 0x55, 0x58, {0x21, 0x00} },
 	{"Packard Bell", "AOA110", "v0.3105", 0x55, 0x58, {0x21, 0x00} },
+	{"Packard Bell", "AOA150", "v0.3105", 0x55, 0x58, {0x20, 0x00} },
 	/* pewpew-terminator */
 	{"", "", "", 0, 0, {0, 0} }
 };
-- 
1.6.4


-- 
Peter Feuerer <peter@piie.net>
