Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbZKGVow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbZKGVow (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 16:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZKGVou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 16:44:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47563 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108AbZKGVou convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 16:44:50 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:44:52 +0000
Message-ID: <1257630292.15927.392.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 07/75] moxa: declare MODULE_FIRMWARE
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/moxa.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index dd0083b..26c9259 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -175,6 +175,9 @@ static unsigned int numports[MAX_BOARDS];
 MODULE_AUTHOR("William Chen");
 MODULE_DESCRIPTION("MOXA Intellio Family Multiport Board Device Driver");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("c218tunx.cod");
+MODULE_FIRMWARE("cp204unx.cod");
+MODULE_FIRMWARE("c320tunx.cod");
 #ifdef MODULE
 module_param_array(type, uint, NULL, 0);
 MODULE_PARM_DESC(type, "card type: C218=2, C320=4");
-- 
1.6.5.2



