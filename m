Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbXHAR7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbXHAR7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764660AbXHAR71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:59:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:40400 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763052AbXHAR7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:59:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=S8qMTqs324w8xqvM8aAh0OmCF/iUDZGZVC4gAKz37kj8kwGfEnGv/MD46MqA5anfL9F9+SfbSB0dB8gKsjqbwC0zPxGDOgydHQ0N/eImcdmCESctP32JqV7xnhbGfOl9VHjB4qs91OMaxwSc7/n3z6Mu70NkOGONFDOOvT3kUv4=
Message-ID: <46B0C9DD.8040701@googlemail.com>
Date: Wed, 01 Aug 2007 19:58:53 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Removal of duplicated include net/wanrouter/wanmain.c
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is no need to include linux/init.h twice

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-mm-clean/net/wanrouter/wanmain.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/net/wanrouter/wanmain.c	2007-08-01 18:14:22.000000000 +0200
@@ -46,7 +46,6 @@
 #include <linux/capability.h>
 #include <linux/errno.h>	/* return codes */
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>	/* support for loadable modules */
 #include <linux/slab.h>		/* kmalloc(), kfree() */
 #include <linux/mm.h>
