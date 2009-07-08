Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbZGHQKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbZGHQKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759945AbZGHQHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:07:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:60004 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759963AbZGHQHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:07:44 -0400
Subject: [PATCH 16/44] includecheck fix: s390, sys_s390.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 21:30:09 +0530
Message-Id: <1247068809.4382.111.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/s390/kernel/sys_s390.c: linux/syscalls.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/s390/kernel/sys_s390.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/s390/kernel/sys_s390.c b/arch/s390/kernel/sys_s390.c
index c7ae4b1..e9d94f6 100644
--- a/arch/s390/kernel/sys_s390.c
+++ b/arch/s390/kernel/sys_s390.c
@@ -29,7 +29,6 @@
 #include <linux/personality.h>
 #include <linux/unistd.h>
 #include <linux/ipc.h>
-#include <linux/syscalls.h>
 #include <asm/uaccess.h>
 #include "entry.h"
 
-- 
1.6.0.6



