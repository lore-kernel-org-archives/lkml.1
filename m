Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbYGDRAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbYGDRAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760326AbYGDQyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:54:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:62463 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407AbYGDQyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:54:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K/MmGJmVFpLqOuvd4BiWRJFRe5dI/knev6Y2P+cHTm1/oui2vJt7VqDW3vU8BTS7RJ
         +g+1YKPCD5lQofJHGJNFALqwIkmQBIzeUglN0oJuQCBwjvM8rkWKrPaa3Bn5oMu1rPyR
         T0oBpt4yMTE/jtP2dMtV0KD4G6HVvHPrL85Uw=
Date: Sat, 5 Jul 2008 01:54:39 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Brian King <brking@us.ibm.com>,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH -mm] fix ipr-use-memory_read_from_buffer.patch
Message-ID: <20080704165438.GD22477@localhost.localdomain>
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
Cc: Brian King <brking@us.ibm.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/ipr.c |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6-mm/drivers/scsi/ipr.c
===================================================================
--- 2.6-mm.orig/drivers/scsi/ipr.c
+++ 2.6-mm/drivers/scsi/ipr.c
@@ -71,6 +71,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/libata.h>
+#include <linux/string.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/processor.h>
