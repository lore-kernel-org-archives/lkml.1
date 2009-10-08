Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZJHHyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZJHHyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 03:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbZJHHyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 03:54:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40843 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbZJHHyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 03:54:40 -0400
Date: Thu, 8 Oct 2009 09:54:03 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Oskar Schirmer <os@emlix.com>
Subject: [PATCH] add missing include in lib/rational.c
Message-ID: <20091008075403.GE30719@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 09:52:29 up 1 day, 20:29, 24 users,  load average: 0.48, 1.58,
	0.88
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Here is a little patch to fix a compiler warning

fixes:

lib/rational.c:62: warning: data definition has no type or storage class
lib/rational.c:62: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
lib/rational.c:62: warning: parameter names (without types) in function declaration

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 lib/rational.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/rational.c b/lib/rational.c
index b3c099b..3ed247b 100644
--- a/lib/rational.c
+++ b/lib/rational.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/rational.h>
+#include <linux/module.h>
 
 /*
  * calculate best rational approximation for a given fraction
-- 
1.6.4.3


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
