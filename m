Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbZF0RFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbZF0RFK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 13:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbZF0RFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 13:05:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:53391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbZF0RE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 13:04:59 -0400
Subject: [PATCH] headers_check fix: linux/netfilter/xt_osf.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Patrick McHardy <kaber@trash.net>, Evgeniy Polyakov <zbr@ioremap.net>,
       Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 22:01:04 +0530
Message-Id: <1246120264.32198.2.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make headers_check' warnings:

  usr/include/linux/netfilter/xt_osf.h:40: found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/linux/netfilter/xt_osf.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/xt_osf.h b/include/linux/netfilter/xt_osf.h
index fd2272e..18afa49 100644
--- a/include/linux/netfilter/xt_osf.h
+++ b/include/linux/netfilter/xt_osf.h
@@ -20,6 +20,8 @@
 #ifndef _XT_OSF_H
 #define _XT_OSF_H
 
+#include <linux/types.h>
+
 #define MAXGENRELEN		32
 
 #define XT_OSF_GENRE		(1<<0)
-- 
1.6.0.6



