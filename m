Return-Path: <linux-kernel-owner+w=401wt.eu-S1760002AbXEUOu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002AbXEUOu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 10:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbXEUOut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 10:50:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbXEUOus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 10:50:48 -0400
Date: Mon, 21 May 2007 10:50:42 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org
Subject: Add Seagate STT20000A to DMA blacklist.
Message-ID: <20070521145042.GA6957@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, bzolnier@gmail.com,
	linux-ide@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=1044
has been open for _four_ years with a patch available.
Here's a rediffed version of the same.

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6/drivers/ide/ide-dma.c~	2007-05-21 10:48:11.000000000 -0400
+++ linux-2.6/drivers/ide/ide-dma.c	2007-05-21 10:48:21.000000000 -0400
@@ -127,7 +127,8 @@ static const struct drive_list_entry dri
 	{ "SAMSUNG CD-ROM SC",	"ALL"		},
 	{ "SanDisk SDP3B-64"	,	"ALL"		},
 	{ "ATAPI CD-ROM DRIVE 40X MAXIMUM",	"ALL"		},
-	{ "_NEC DV5800A",               "ALL"           },  
+	{ "_NEC DV5800A",               "ALL"           },
+	{ "Seagate STT20000A",          "ALL"           },
 	{ NULL			,	NULL		}
 
 };

-- 
http://www.codemonkey.org.uk
