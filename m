Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbZF0RGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbZF0RGN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 13:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbZF0RF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 13:05:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:53415 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbZF0RF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 13:05:58 -0400
Subject: [PATCH] headers_check fix: linux/pps.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Rodolfo Giometti <giometti@linux.it>, Sam Ravnborg <sam@ravnborg.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 22:03:34 +0530
Message-Id: <1246120414.32198.5.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make headers_check' warnings:

  usr/include/linux/pps.h:52: found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/linux/pps.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/pps.h b/include/linux/pps.h
index cfe5c72..0194ab0 100644
--- a/include/linux/pps.h
+++ b/include/linux/pps.h
@@ -22,6 +22,8 @@
 #ifndef _PPS_H_
 #define _PPS_H_
 
+#include <linux/types.h>
+
 #define PPS_VERSION		"5.3.6"
 #define PPS_MAX_SOURCES		16		/* should be enough... */
 
-- 
1.6.0.6



