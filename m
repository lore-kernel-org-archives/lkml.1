Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbYHTVFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbYHTVFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYHTVEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:04:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:53253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbYHTVEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:04:54 -0400
Subject: patch uio-uio_pdrv-fix-memory-leak.patch added to gregkh-2.6 tree
To: Uwe.Kleine-Koenig@digi.com, gregkh@suse.de, greg@kroah.com,
       hjk@linutronix.de, linux-kernel@vger.kernel.org, magnus.damm@gmail.com
From: <gregkh@suse.de>
Date: Wed, 20 Aug 2008 13:56:15 -0700
In-Reply-To: <1215767437-20583-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
Message-ID: <12192657752041@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: UIO: uio_pdrv: fix memory leak

to my gregkh-2.6 tree.  Its filename is

    uio-uio_pdrv-fix-memory-leak.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From Uwe.Kleine-Koenig@digi.com  Wed Aug 20 13:44:18 2008
From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Date: Fri, 11 Jul 2008 11:10:36 +0200
Subject: UIO: uio_pdrv: fix memory leak
To: Greg KH <greg@kroah.com>, "Hans J. Koch" <hjk@linutronix.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, <linux-kernel@vger.kernel.org>
Message-ID: <1215767437-20583-2-git-send-email-Uwe.Kleine-Koenig@digi.com>


Thanks to Magnus Damm for pointing that out.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Acked-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/uio/uio_pdrv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/uio/uio_pdrv.c
+++ b/drivers/uio/uio_pdrv.c
@@ -88,6 +88,8 @@ static int uio_pdrv_remove(struct platfo
 
 	uio_unregister_device(pdata->uioinfo);
 
+	kfree(pdata);
+
 	return 0;
 }
 


Patches currently in gregkh-2.6 which might be from Uwe.Kleine-Koenig@digi.com are

driver-core.current/uio-uio_pdrv-fix-license-specification.patch
driver-core.current/uio-uio_pdrv-fix-memory-leak.patch
driver-core.current/uio-generic-irq-handling-for-some-uio-platform-devices.patch
