Return-Path: <linux-kernel-owner+w=401wt.eu-S934374AbYBGAa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934374AbYBGAa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764259AbYBGAAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:00:21 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:40528 "EHLO
	mk-filter-2-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764147AbYBGAAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:00:16 -0500
X-Trace: 668975104/mk-filter-2.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAAvZqUdRAVlC/2dsb2JhbACBWassgXY
Subject: [PATCH] - SH/Dreamcast - additional patch to maple.h
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Greg KH <greg@kroah.com>
Cc: Paul Mundt <lethal@users.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
In-Reply-To: <20080206232349.GA15654@kroah.com>
References: <1202337981.6162.8.camel@localhost.localdomain>
	 <1202338431.6162.15.camel@localhost.localdomain>
	 <20080206230127.GA9614@kroah.com>
	 <1202339114.6162.17.camel@localhost.localdomain>
	 <20080206232349.GA15654@kroah.com>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 23:59:56 +0000
Message-Id: <1202342396.6162.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the now unneeded registration check variable from
struct maple_device. (This patch assumes the include/linux/maple.h file
has already been patched for whitespace errors by
http://lkml.org/lkml/2008/2/6/327)

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>


diff --git a/include/linux/maple.h b/include/linux/maple.h
index 1334062..3f01e2b 100644
--- a/include/linux/maple.h
+++ b/include/linux/maple.h
@@ -56,7 +56,6 @@ struct maple_device {
 	unsigned char port, unit;
 	char product_name[32];
 	char product_licence[64];
-	int registered;
 	struct device dev;
 };

