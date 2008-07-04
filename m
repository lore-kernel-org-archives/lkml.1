Return-Path: <linux-kernel-owner+w=401wt.eu-S1761634AbYGDRB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634AbYGDRB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760848AbYGDRAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 13:00:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:7814 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759705AbYGDRAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 13:00:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KMUFQuoa5qzHxX5ee7NXYNAo9VvHdRWbz01cAtxh+7zqBk64UAZbYjjn4Arp69yscM
         fhPq50GButBWvpGbXjjq43xVnAK8B1Nr9I3I4vUh0qVi5NuuTjCY+73OB9hbRg1VTRQM
         bmTwPCXNfrBUtcwRuHPwkHKumISC8a+d6u2jo=
Date: Sat, 5 Jul 2008 02:00:05 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Abhay Salunke <Abhay_Salunke@dell.com>,
       Zhang Rui <rui.zhang@intel.com>, Matt Domsch <Matt_Domsch@dell.com>
Subject: [PATCH -mm] fix dell_rbu-use-memory_read_from_buffer.patch
Message-ID: <20080704170004.GH22477@localhost.localdomain>
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
Cc: Abhay Salunke <Abhay_Salunke@dell.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
---
 drivers/firmware/dell_rbu.c |    1 -
 1 file changed, 1 deletion(-)

Index: 2.6-mm/drivers/firmware/dell_rbu.c
===================================================================
--- 2.6-mm.orig/drivers/firmware/dell_rbu.c
+++ 2.6-mm/drivers/firmware/dell_rbu.c
@@ -44,7 +44,6 @@
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
 #include <linux/dma-mapping.h>
-#include <linux/fs.h>
 
 MODULE_AUTHOR("Abhay Salunke <abhay_salunke@dell.com>");
 MODULE_DESCRIPTION("Driver for updating BIOS image on DELL systems");
