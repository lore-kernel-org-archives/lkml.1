Return-Path: <linux-kernel-owner+w=401wt.eu-S933619AbYEHVoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619AbYEHVoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933517AbYEHVnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:43:39 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:53764 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933499AbYEHVnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:43:37 -0400
Date: Fri, 9 May 2008 00:42:13 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: sh migor_defconfig build breakage
Message-ID: <20080508214213.GE22887@cs181133002.pp.htv.fi>
References: <20080508203949.GC22887@cs181133002.pp.htv.fi> <48236E59.8070400@sgi.com> <4823711D.70401@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4823711D.70401@sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 02:31:09PM -0700, Mike Travis wrote:
> Mike Travis wrote:
> > Adrian Bunk wrote:
> >> Commit aa6b54461cc5c0019b9d792adf3176b444c10763
> >> (asm-generic: add node_to_cpumask_ptr macro)
> >> causes the following build error with migor_defconfig:
> >>
> >> <--  snip  -->
> >>
> >> ...
> >>   CC      arch/sh/kernel/asm-offsets.s
> >> In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mm.h:8,
> >>                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/kernel/asm-offsets.c:13:
> >> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/gfp.h: In function 'alloc_pages_node':
> >> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/gfp.h:190: 
> >> error: implicit declaration of function 'cpu_to_node'
> >> make[2]: *** [arch/sh/kernel/asm-offsets.s] Error 1
> >>
> >> <--  snip  -->
> >>
> >> cu
> >> Adrian
> >>
> > 
> > Hi Adrian,
> > 
> > Thanks for the feedback, I'll cross-compile test this config.
> > 
> > Mike
> 
> 
> Ouch.  I just discovered I don't have a cross-compiler for 'sh'.  Can you point me
> towards one?

Mine are self-built.

The LinuxSH project offers binary ones at
  http://www.linux-sh.org

> Thanks,
> Mike

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

