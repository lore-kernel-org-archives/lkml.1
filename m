Return-Path: <linux-kernel-owner+w=401wt.eu-S933793AbXDASSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793AbXDASSF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933769AbXDASRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:17:35 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:39960 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933795AbXDASRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:17:08 -0400
Date: Sun, 1 Apr 2007 20:16:22 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH 11/16] samba-eintr-fix.diff
In-Reply-To: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704012009230.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Jones
Already posted at http://lkml.org/lkml/2005/7/7/255

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Dave Jones <Dave Jones <davej@redhat.com>

 request.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.21-rc5/fs/smbfs/request.c
===================================================================
--- linux-2.6.21-rc5.orig/fs/smbfs/request.c
+++ linux-2.6.21-rc5/fs/smbfs/request.c
@@ -347,6 +347,7 @@ int smb_add_request(struct smb_request *
 			smb_rput(req);
 		}
 		smb_unlock_server(server);
+		return -EINTR;
 	}
 
 	if (!timeleft) {
#<EOF>
