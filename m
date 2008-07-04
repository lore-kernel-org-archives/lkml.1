Return-Path: <linux-kernel-owner+w=401wt.eu-S1761501AbYGDRBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761501AbYGDRBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761202AbYGDQ7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:59:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:8343 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761192AbYGDQ7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:59:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZsxkYcB11IA7OhVcfyvbzlAnWhFrriN1Sn1du5V7ZPcoXNVZpTOxp4q/yb4RNoRIO0
         cvF1AxhMWORoEYhxmvOGf9Z7KtsydSYw9KC8iGEC9hVl6sO3YynAmqUC3o9K6v9UaObO
         2QLLFsnRx33HQ/fd4tmRnYEUh9rMqElU8T00M=
Date: Sat, 5 Jul 2008 01:58:53 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Markus Rechberger <markus.rechberger@amd.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH -mm] fix firmware-use-memory_read_from_buffer.patch
Message-ID: <20080704165853.GG22477@localhost.localdomain>
References: <200807040647.m646lXpN017508@imap1.linux-foundation.org> <1215182555.5413.8.camel@localhost.localdomain> <20080704163942.GA15214@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20080704163942.GA15214@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now memory_read_from_buffer() belongs in string.h

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Markus Rechberger <markus.rechberger@amd.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/base/firmware_class.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6-mm/drivers/base/firmware_class.c
===================================================================
--- 2.6-mm.orig/drivers/base/firmware_class.c
+++ 2.6-mm/drivers/base/firmware_class.c
@@ -17,7 +17,7 @@
 #include <linux/bitops.h>
 #include <linux/mutex.h>
 #include <linux/kthread.h>
-#include <linux/fs.h>
+#include <linux/string.h>
 
 #include <linux/firmware.h>
 #include "base.h"
