Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYCTEUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYCTEUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 00:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbYCTEUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 00:20:16 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:35243 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbYCTEUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 00:20:14 -0400
Date: Wed, 19 Mar 2008 21:19:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: akpm@linux-foundation.org, torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [mmotm build error] Re: [PATCH,RESEND] Basic braille screen
 reader support
Message-Id: <20080319211924.4533aec2.randy.dunlap@oracle.com>
In-Reply-To: <20080320020758.GA4545@implementation>
References: <20080204031842.GE4439@implementation>
	<20080205220054.GD4394@implementation>
	<20080319115726.a4ca9883.randy.dunlap@oracle.com>
	<20080320020758.GA4545@implementation>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008 02:07:59 +0000 Samuel Thibault wrote:

> Randy Dunlap, le Wed 19 Mar 2008 11:57:26 -0700, a écrit :
> > when O=dir is used in make:
> > 
> >   CC      drivers/accessibility/braille/braille_console.o
> > Assembler messages:
> > Fatal error: can't create drivers/accessibility/braille/braille_console.o: No such file or directory
> >   CC      crypto/aes_generic.o
> > make[3]: *** [drivers/accessibility/braille/braille_console.o] Error 2
> > make[2]: *** [drivers/accessibility] Error 2
> > make[1]: *** [drivers] Error 2
> 
> Oh, right, the patch below should fix it
> 

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> 
> Properly recurse Makefiles into accessibility and accessibility/braille/
> 
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> 
> --- linux-2.6.24.1-perso/drivers/accessibility/Makefile.orig	2008-03-20 01:51:09.000000000 +0000
> +++ linux-2.6.24.1-perso/drivers/accessibility/Makefile	2008-03-20 01:52:30.000000000 +0000
> @@ -1 +1 @@
> -obj-$(CONFIG_A11Y_BRAILLE_CONSOLE)		+= braille/braille_console.o
> +obj-y				+= braille/
> --- /dev/null	2008-03-20 02:39:28.130012041 +0000
> +++ linux-2.6.24.1-perso/drivers/accessibility/braille/Makefile	2008-03-20 01:52:44.000000000 +0000
> @@ -0,0 +1 @@
> +obj-$(CONFIG_A11Y_BRAILLE_CONSOLE)		+= braille_console.o
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


---
~Randy
