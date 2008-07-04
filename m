Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbYGDRAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbYGDRAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758992AbYGDQ4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:56:05 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:61260 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759908AbYGDQ4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:56:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sGJX+EcF/btTA6JZx/6bjMwJIq6UOn38qSzgOdYAfSJGpkn5sezrfXp3Ie/NVDo1gR
         733psKCoztKO6a3mTyl8DHs7IxfmfKywG/y5xE8Ek1mKQVbuN/OiBTSJG7Hdsp/M82iy
         A40doCxNUNT2yeL2O8LpNoeiHc66hjgiyK7cU=
Date: Sat, 5 Jul 2008 01:55:57 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Doug Warzecha <Douglas_Warzecha@dell.com>,
       Zhang Rui <rui.zhang@intel.com>, Matt Domsch <Matt_Domsch@dell.com>
Subject: [PATCH -mm] fix dcdbas-use-memory_read_from_buffer.patch
Message-ID: <20080704165556.GE22477@localhost.localdomain>
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
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
---
 drivers/firmware/dcdbas.c |    1 -
 1 file changed, 1 deletion(-)

Index: 2.6-mm/drivers/firmware/dcdbas.c
===================================================================
--- 2.6-mm.orig/drivers/firmware/dcdbas.c
+++ 2.6-mm/drivers/firmware/dcdbas.c
@@ -34,7 +34,6 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/mutex.h>
-#include <linux/fs.h>
 #include <asm/io.h>
 
 #include "dcdbas.h"
