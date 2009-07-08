Return-Path: <linux-kernel-owner+w=401wt.eu-S1758519AbZGHQDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519AbZGHQDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758238AbZGHQD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:03:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:53128 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758228AbZGHQD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:03:27 -0400
Subject: [PATCH 21/44] includecheck fix: Documentation, cfag12864b-example.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Miguel Ojeda Sandonis <maxextreme@gmail.com>,
       Paulo Marques <pmarques@grupopie.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:32:49 +0530
Message-Id: <1247065369.4382.54.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  Documentation/auxdisplay/cfag12864b-example.c: string.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 Documentation/auxdisplay/cfag12864b-example.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/Documentation/auxdisplay/cfag12864b-example.c b/Documentation/auxdisplay/cfag12864b-example.c
index 2caeea5..156bcaa 100644
--- a/Documentation/auxdisplay/cfag12864b-example.c
+++ b/Documentation/auxdisplay/cfag12864b-example.c
@@ -194,7 +194,6 @@ void cfag12864b_blit(void)
  */
 
 #include <stdio.h>
-#include <string.h>
 
 #define EXAMPLES	6
 
-- 
1.6.0.6



