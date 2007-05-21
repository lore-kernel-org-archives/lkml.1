Return-Path: <linux-kernel-owner+w=401wt.eu-S935149AbXEUTqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935149AbXEUTqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933840AbXEUT2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:28:11 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52584 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933823AbXEUT2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:28:08 -0400
Message-Id: <20070521191751.547922000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:17:08 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       bunk@stusta.de
Subject: [patch 56/69] SERIAL SUNHV: Add an ID string.
Content-Disposition: inline; filename=serial-sunhv-add-an-id-string.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David Miller <davem@davemloft.net>

The 'compatible' property can be SUNW,sun4v-console as
well as 'qcn'.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/serial/sunhv.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-2.6.21.1.orig/drivers/serial/sunhv.c
+++ linux-2.6.21.1/drivers/serial/sunhv.c
@@ -493,6 +493,10 @@ static struct of_device_id hv_match[] = 
 		.name = "console",
 		.compatible = "qcn",
 	},
+	{
+		.name = "console",
+		.compatible = "SUNW,sun4v-console",
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, hv_match);

-- 
