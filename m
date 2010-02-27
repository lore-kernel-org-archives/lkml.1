Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967995Ab0B0Ijh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 03:39:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:37995 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967944Ab0B0Ijg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 03:39:36 -0500
Subject: [PATCH] includecheck fix for kernel/params.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: =?ISO-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Feb 2010 14:07:48 +0530
Message-Id: <1267259868.26906.7.camel@i7.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the following 'make includecheck' warning:
  kernel/params.c: linux/string.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: André Goddard Rosa <andre.goddard@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/params.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index cf1b691..8d95f54 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -24,7 +24,6 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
-#include <linux/string.h>
 
 #if 0
 #define DEBUGP printk
-- 
1.6.6


