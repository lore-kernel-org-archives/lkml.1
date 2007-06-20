Return-Path: <linux-kernel-owner+w=401wt.eu-S1764006AbXFTSu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764006AbXFTSu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763546AbXFTSpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:45:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:32707 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763608AbXFTSpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:45:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=WQVxvSLG07Kw5lIe9JQ3kGq6A52lEYIKe8ZUAGUeNgb+jnUZpjTRcKZ2L4QvwK0qa/fewdME1ZTmfyT8ATcJowVoIemb1cMe6tXxxIMXNPHlA0IKHC6mkM/R41a4DmRGhsCy2P41VK/3qlAyhQiz/02sYVk7BKn2l/g85z7wwSU=
Message-ID: <467975C1.2040200@googlemail.com>
Date: Wed, 20 Jun 2007 20:45:21 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Vasily Tarasov <vtaras@openvz.org>,
       Jan Kara <jack@ucw.cz>
Subject: [PATCH] fs/quota.c build fix (Re: mm snapshot broken-out-2007-06-20-10-12.tar.gz
 uploaded)
References: <200706201714.l5KHEYh6010297@imap1.linux-foundation.org>
In-Reply-To: <200706201714.l5KHEYh6010297@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org pisze:
> The mm snapshot broken-out-2007-06-20-10-12.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-06-20-10-12.tar.gz
> 
> It contains the following patches against 2.6.22-rc5:
> 

  CC      fs/quota.o
fs/quota.c:13:24: error: asm/compat.h: No such file or directory
make[1]: *** [fs/quota.o] Error 1
make: *** [fs] Error 2

diskquota-32bit-quota-tools-on-64bit-architectures.patch

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-work-clean/fs/quota.c	2007-06-20 20:38:52.000000000 +0200
+++ linux-work/fs/quota.c	2007-06-20 20:35:02.000000000 +0200
@@ -10,7 +10,7 @@
 #include <linux/slab.h>
 #include <asm/current.h>
 #include <asm/uaccess.h>
-#include <asm/compat.h>
+#include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
