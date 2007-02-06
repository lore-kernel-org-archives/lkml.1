Return-Path: <linux-kernel-owner+w=401wt.eu-S965456AbXBFVJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965456AbXBFVJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965474AbXBFVJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:09:47 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:60585 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965456AbXBFVJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:09:46 -0500
Date: Tue, 6 Feb 2007 22:09:45 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: cornelia.huck@de.ibm.com
Subject: [S390] cio: Don't spam debug feature.
Message-ID: <20070206210945.GA30335@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

[S390] cio: Don't spam debug feature.

Lower priority of "Blacklisted device detected" messages so we don't
overwrite more useful messages.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/cio.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/cio/cio.c linux-2.6-patched/drivers/s390/cio/cio.c
--- linux-2.6/drivers/s390/cio/cio.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/cio.c	2007-02-06 21:43:33.000000000 +0100
@@ -585,7 +585,7 @@ cio_validate_subchannel (struct subchann
 		 * This device must not be known to Linux. So we simply
 		 * say that there is no device and return ENODEV.
 		 */
-		CIO_MSG_EVENT(0, "Blacklisted device detected "
+		CIO_MSG_EVENT(4, "Blacklisted device detected "
 			      "at devno %04X, subchannel set %x\n",
 			      sch->schib.pmcw.dev, sch->schid.ssid);
 		err = -ENODEV;
