Return-Path: <linux-kernel-owner+w=401wt.eu-S933055AbXB0MTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbXB0MTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 07:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933040AbXB0MTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 07:19:55 -0500
Received: from jaguar.mkp.net ([192.139.46.146]:51584 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933055AbXB0MTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 07:19:55 -0500
To: Andrew Morton <akpm@osdl.org>
Cc: Dave Jones <davej@redhat.com>, ayoung@sgi.com,
       Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org
Subject: [patch] fix build breakage in sgi-agp.c
From: Jes Sorensen <jes@sgi.com>
Date: 27 Feb 2007 07:19:53 -0500
Message-ID: <yq04pp7rdw6.fsf@jaguar.mkp.net>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This one fixes the build breakage introduced in the recent const
change patch applied to drivers/char/agp

Cheers,
Jes

Fix build breakage from recent const changes.

Signed-off-by: Jes Sorensen <jes@sgi.com>

---
 drivers/char/agp/sgi-agp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/char/agp/sgi-agp.c
===================================================================
--- linux-2.6.orig/drivers/char/agp/sgi-agp.c
+++ linux-2.6/drivers/char/agp/sgi-agp.c
@@ -247,7 +247,7 @@ static struct agp_bridge_data *sgi_tioca
 	return bridge;
 }
 
-struct const agp_bridge_driver sgi_tioca_driver = {
+static const struct agp_bridge_driver sgi_tioca_driver = {
 	.owner = THIS_MODULE,
 	.size_type = U16_APER_SIZE,
 	.configure = sgi_tioca_configure,
