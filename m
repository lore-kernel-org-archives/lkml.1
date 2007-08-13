Return-Path: <linux-kernel-owner+w=401wt.eu-S947467AbXHMOtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947467AbXHMOtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S945106AbXHMMHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:07:32 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:56860 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S945009AbXHMMH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:07:28 -0400
Date: Mon, 13 Aug 2007 13:07:27 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>, dtor@mail.ru,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] SERIO: Fix modpost warning.
Message-ID: <20070813120727.GA28329@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i8042_unregister_ports's only caller i8042_remove is a __devexit function
so make it __devexit too.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 3888dc3..ed286aa 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1038,7 +1038,7 @@ static void __devinit i8042_register_ports(void)
 	}
 }
 
-static void __devinit i8042_unregister_ports(void)
+static void __devexit i8042_unregister_ports(void)
 {
 	int i;
 
