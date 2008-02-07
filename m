Return-Path: <linux-kernel-owner+w=401wt.eu-S932740AbYBGUuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740AbYBGUuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757070AbYBGUuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:50:24 -0500
Received: from ns1.suse.de ([195.135.220.2]:44864 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbYBGUuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:50:23 -0500
Date: Thu, 7 Feb 2008 12:46:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       mkrufky@hauppauge.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 01/45] DVB: cx23885: add missing subsystem ID for Hauppauge
	HVR1800 Retail
Message-ID: <20080207204618.GB16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-cx23885-add-missing-subsystem-id-for-hauppauge-hvr1800-retail.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Krufky <mkrufky@linuxtv.org>

[PATCH] DVB: cx23885: add missing subsystem ID for Hauppauge HVR1800 Retail

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

---
 Documentation/video4linux/CARDLIST.cx23885  |    2 +-
 drivers/media/video/cx23885/cx23885-cards.c |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- linux-2.6.24.1.orig/Documentation/video4linux/CARDLIST.cx23885
+++ linux-2.6.24.1/Documentation/video4linux/CARDLIST.cx23885
@@ -1,5 +1,5 @@
   0 -> UNKNOWN/GENERIC                                     [0070:3400]
   1 -> Hauppauge WinTV-HVR1800lp                           [0070:7600]
-  2 -> Hauppauge WinTV-HVR1800                             [0070:7800,0070:7801]
+  2 -> Hauppauge WinTV-HVR1800                             [0070:7800,0070:7801,0070:7809]
   3 -> Hauppauge WinTV-HVR1250                             [0070:7911]
   4 -> DViCO FusionHDTV5 Express                           [18ac:d500]
--- linux-2.6.24.1.orig/drivers/media/video/cx23885/cx23885-cards.c
+++ linux-2.6.24.1/drivers/media/video/cx23885/cx23885-cards.c
@@ -138,6 +138,10 @@ struct cx23885_subid cx23885_subids[] = 
 		.card      = CX23885_BOARD_HAUPPAUGE_HVR1800,
 	},{
 		.subvendor = 0x0070,
+		.subdevice = 0x7809,
+		.card      = CX23885_BOARD_HAUPPAUGE_HVR1800,
+	},{
+		.subvendor = 0x0070,
 		.subdevice = 0x7911,
 		.card      = CX23885_BOARD_HAUPPAUGE_HVR1250,
 	},{

-- 
