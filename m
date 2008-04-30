Return-Path: <linux-kernel-owner+w=401wt.eu-S1762436AbYD3RsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762436AbYD3RsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758246AbYD3Rrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:47:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57618 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487AbYD3Rrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:47:51 -0400
Date: Wed, 30 Apr 2008 19:47:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch, -git] usb: build fix
Message-ID: <20080430174739.GA26418@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this config:

  http://redhat.com/~mingo/misc/config-Wed_Apr_30_15_12_48_CEST_2008.bad

fails to build due to an #error. Turn that into a #warning instead to 
not break randconfig builds unnecessarily.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/usb/cdc_subset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/net/usb/cdc_subset.c
===================================================================
--- linux.orig/drivers/net/usb/cdc_subset.c
+++ linux/drivers/net/usb/cdc_subset.c
@@ -218,7 +218,7 @@ static const struct driver_info	blob_inf
 /*-------------------------------------------------------------------------*/
 
 #ifndef	HAVE_HARDWARE
-#error You need to configure some hardware for this driver
+#warning You need to configure some hardware for this driver
 #endif
 
 /*
