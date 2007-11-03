Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbXKCXQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbXKCXQn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbXKCXQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:16:37 -0400
Received: from smtprelay12.ispgateway.de ([80.67.29.29]:33502 "EHLO
	smtprelay12.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbXKCXQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:16:36 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Nov 2007 19:16:35 EDT
Message-ID: <472CFFBD.2050007@the-axe-effect.de>
Date: Sun, 04 Nov 2007 00:09:49 +0100
From: Tobias Hoffmann <lk-list@the-axe-effect.de>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: drive side 80-wire cable detection failed
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On my NV3 board with a Samsung SP1634N Harddisk I wrongly got
"drive side 80-wire cable detection failed" with the current kernel.

A possible fix is attached.

Please CC any replies as I'm not on the list.

  Tobias


diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index dcda0f1..e3cfd6c 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -588,6 +588,7 @@ EXPORT_SYMBOL_GPL(ide_in_drive_list);
 static const struct drive_list_entry ivb_list[] = {
        { "QUANTUM FIREBALLlct10 05"    , "A03.0900"    },
        { "TSSTcorp CDDVDW SH-S202J"    , "SB00"        },
+       { "SAMSUNG SP1634N"             , "UZ100-03"    },
        { NULL                          , NULL          }
 };

