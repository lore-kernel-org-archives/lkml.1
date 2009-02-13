Return-Path: <linux-kernel-owner+w=401wt.eu-S1760913AbZBMOfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760913AbZBMOfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbZBMOfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:35:41 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:55394 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758053AbZBMOfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:35:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=p4Pmz1NX8QQbBAVL6Pa2rBcTcyhf/4IH3KQV7G1fw3+pTxek2/FMhtmdk5IrZLFifX
         zH9JxZfAM2Nkci8CUwUMT1p87euPUC3fqOxzRb9s6sE2OS9oM10oSNEML0lEmOEp2Urx
         AGE5iN/qZojca7MEgY9alBTGVkmqx+gIdF0eA=
Date: Fri, 13 Feb 2009 17:35:32 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: zbr@ioremap.net, gregkh@suse.de, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH next] Stagging: pohmelfs/net.c: include vmalloc.h
Message-ID: <20090213143532.GA7266@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on Sparc64:
drivers/staging/pohmelfs/net.c:33: error: implicit declaration of function 'vmalloc'
drivers/staging/pohmelfs/net.c:42: error: implicit declaration of function 'vfree'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/pohmelfs/net.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/pohmelfs/net.c b/drivers/staging/pohmelfs/net.c
index d161237..c9b8540 100644
--- a/drivers/staging/pohmelfs/net.c
+++ b/drivers/staging/pohmelfs/net.c
@@ -22,6 +22,7 @@
 #include <linux/poll.h>
 #include <linux/swap.h>
 #include <linux/syscalls.h>
+#include <linux/vmalloc.h>

 #include "netfs.h"

