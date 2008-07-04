Return-Path: <linux-kernel-owner+w=401wt.eu-S1761316AbYGDQ7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761316AbYGDQ7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760061AbYGDQxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:53:14 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:55112 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758992AbYGDQxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s54ecxjdWfBpXSS5B+kL3HU2qc2rBQMWjij1p5U4CVwr26U7UJHoj0VjJdeZwA0XDC
         15F6sE2l63EihL5Dxu6ZXSYpRPsmxa2CiRB+yToNv7JYFe1gVN0xdoFmnvW34iyRbtxR
         QXxU3hiQFytuT9+TccGTITTLHYBy7BShVMeOs=
Date: Sat, 5 Jul 2008 01:53:06 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andrew Vasquez <linux-driver@qlogic.com>,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
       Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Seokmann Ju <seokmann.ju@qlogic.com>
Subject: [PATCH -mm] fix qla2xxx-use-memory_read_from_buffer.patch
Message-ID: <20080704165305.GC22477@localhost.localdomain>
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
Cc: Andrew Vasquez <linux-driver@qlogic.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6-mm/drivers/scsi/qla2xxx/qla_attr.c
===================================================================
--- 2.6-mm.orig/drivers/scsi/qla2xxx/qla_attr.c
+++ 2.6-mm/drivers/scsi/qla2xxx/qla_attr.c
@@ -8,7 +8,7 @@
 
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
-#include <linux/fs.h>
+#include <linux/string.h>
 
 static int qla24xx_vport_disable(struct fc_vport *, bool);
 
