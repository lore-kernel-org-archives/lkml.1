Return-Path: <linux-kernel-owner+w=401wt.eu-S1760672AbZAWOZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672AbZAWOZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 09:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbZAWOZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 09:25:32 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:36997 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbZAWOZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 09:25:31 -0500
Date: Fri, 23 Jan 2009 07:25:30 -0700
From: David Altobelli <david.altobelli@hp.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, david.altobelli@hp.com
Subject: [PATCH] increment hpilo version
Message-ID: <20090123142529.GA5298@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump hpilo module version to indicate that the open/close bug is fixed.

Please CC me on any replies.

Signed-off-by: David Altobelli <david.altobelli@hp.com>
---

--- drivers/misc/hpilo.c.orig	2009-01-23 08:16:46.000000000 -0600
+++ drivers/misc/hpilo.c	2009-01-23 08:16:58.000000000 -0600
@@ -758,7 +758,7 @@ static void __exit ilo_exit(void)
 	class_destroy(ilo_class);
 }
 
-MODULE_VERSION("0.05");
+MODULE_VERSION("0.06");
 MODULE_ALIAS(ILO_NAME);
 MODULE_DESCRIPTION(ILO_NAME);
 MODULE_AUTHOR("David Altobelli <david.altobelli@hp.com>");
