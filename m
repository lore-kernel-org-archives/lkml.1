Return-Path: <linux-kernel-owner+w=401wt.eu-S1760682AbYDKRKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760682AbYDKRKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 13:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759521AbYDKRKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 13:10:33 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46049 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbYDKRKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 13:10:33 -0400
Date: Fri, 11 Apr 2008 20:09:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Dave Jones <davej@redhat.com>,
       drepper@redhat.com, mingo@redhat.com, tglx@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] Fix compile breakage caused by asmlinkage_protect
Message-ID: <20080411170934.GB25788@cs181133002.pp.htv.fi>
References: <alpine.LFD.1.00.0804101447240.3143@woody.linux-foundation.org> <20080410223738.80A8326F992@magilla.localdomain> <20080411114654.GA12270@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0804110744100.3143@woody.linux-foundation.org> <20080411151156.GJ9785@ZenIV.linux.org.uk> <alpine.LFD.1.00.0804110821400.3143@woody.linux-foundation.org> <20080411153728.GG27073@phobos.i.cabal.ca> <1207929787.21379.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1207929787.21379.5.camel@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 06:03:07PM +0200, Martin Schwidefsky wrote:
>...
> --- a/arch/s390/kernel/Makefile
> +++ b/arch/s390/kernel/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for the linux kernel.
>  #
>  
> -EXTRA_AFLAGS	:= -traditional
> +EXTRA_AFLAGS	:= 
>...

You can simply ditch the line.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

