Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbYAQUmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbYAQUmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757113AbYAQUmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:42:19 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1956 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757062AbYAQUmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:42:17 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [-mm Patch] uml: fix a building error
Date: Thu, 17 Jan 2008 21:42:12 +0100
User-Agent: KMail/1.9.7
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "WANG Cong" <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       "Jeff Dike" <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       "David Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <20080117105606.ff89e9e9.akpm@linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE5E90DF@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE5E90DF@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801172142.14326.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> >> > This patch fixes this building error:
> >> > ...
> >> > drivers/char/mem.c: In function 'read_mem':
> >> > drivers/char/mem.c:136: error: implicit declaration of 
> >function 'unxlate_dev_mem_ptr'
> >> > ...
> >> 
> >> I see this on sparc64 as well:
> >> 
> >>   CC      drivers/char/mem.o
> >> drivers/char/mem.c: In function 'read_mem':
> >> drivers/char/mem.c:136: error: implicit declaration of 
> >function 'unxlate_dev_mem_ptr'
> >> make[2]: *** [drivers/char/mem.o] Error 1
> >> make[1]: *** [drivers/char] Error 2
> >> make: *** [drivers] Error 2
> >> 
> >> Does sparc64 need similar fix?
> >> 
> >
> >The PAT patches strike again.
> >
> >Ingo, I think you might need to toss some cross-compilers into 
> >that build
> >test setup of yours.
> 
> These functions were defined for other archs in asm-generic/iomap.h.
> We need all archs including it in io.h. I now see only few archs are
> including it..
>
> Apart from unxlate, there is also ioremap_wc which is defined in the
> same way.
> 
> I can send a patch for this. But, I don't have cross compiler setup for
> all archs to test. Andrew, I will need your help.

I can confirm that this fixes the build problem for sparc64 here.

Regards,

	Mariusz
