Return-Path: <linux-kernel-owner+w=401wt.eu-S1750900AbXCWRT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900AbXCWRT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 13:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbXCWRT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 13:19:27 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:32777 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750900AbXCWRT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 13:19:26 -0400
Date: Fri, 23 Mar 2007 18:19:29 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Nick Piggin <npiggin@suse.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [1/6] 2.6.21-rc4: known regressions
Message-ID: <20070323171929.GL752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070318184908.GU752@stusta.de> <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org> <46020385.50301@yahoo.com.au> <Pine.LNX.4.64.0703220813340.6730@woody.linux-foundation.org> <1174612132.16068.114.camel@localhost.localdomain> <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org> <20070323021115.GA11147@wotan.suse.de> <6bffcb0e0703230051i5accb180r7bd0fb16de85198a@mail.gmail.com> <20070323093738.GB11577@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070323093738.GB11577@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 10:37:38AM +0100, Nick Piggin wrote:
> On Fri, Mar 23, 2007 at 08:51:13AM +0100, Michal Piotrowski wrote:
> > On 23/03/07, Nick Piggin <npiggin@suse.de> wrote:
> > >>
> > >> and that in turn points to the kernel log:
> > >>
> > >>       
> > >http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4/git-console.log
> > >
> > >Seems convincing. Michal, can you post your .config, and if you had
> > >dynticks and hrtimers enabled, try reproducing without them?
> > >
> > 
> > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4/git-config
> > 
> > I don't know how to reproduce this bug on 2.6.21-rc4.On 2.6.21-rc2-mm1
> > it was very simple, just run youtube, bash_shared_mapping etc. In fact
> > I didn't see this bug for a week.
> 
> OK... for some reason this is listed as a regression against 2.6.21-rc4.
>...

Due to
   http://lkml.org/lkml/2007/3/16/288

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

