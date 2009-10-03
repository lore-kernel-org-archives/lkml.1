Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZJCURP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZJCURP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 16:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbZJCURO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 16:17:14 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44436 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbZJCURO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 16:17:14 -0400
Date: Sat, 3 Oct 2009 22:16:34 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/input/misc/winbond-cir.c needs LEDS_TRIGGERS
Message-ID: <20091003201634.GA29224@hardeman.nu>
Mail-Followup-To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/input/misc/winbond-cir.c depends on LEDS_TRIGGERS

Add an appropriate select to drivers/input/misc/Kconfig

Signed-off-by: David Härdeman <david@hardeman.nu>

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 02f4f8f..a9bb254 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -227,6 +227,7 @@ config INPUT_WINBOND_CIR
 	depends on X86 && PNP
 	select NEW_LEDS
 	select LEDS_CLASS
+	select LEDS_TRIGGERS
 	select BITREVERSE
 	help
 	  Say Y here if you want to use the IR remote functionality found
