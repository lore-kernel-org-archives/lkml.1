Return-Path: <linux-kernel-owner+w=401wt.eu-S933212AbYDOVbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbYDOVbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933096AbYDOVbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:31:04 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:49668 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933113AbYDOVbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:31:01 -0400
Date: Wed, 16 Apr 2008 00:29:49 +0300
From: Adrian Bunk <bunk@stusta.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Soeren Sonnenburg <kernel@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Adrian Bunk <bunk@kernel.org>, "Carlos R. Mafra" <crmafra2@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Lord <lkml@rtr.ca>
Subject: Re: [Bug #10117] 2.6.25-current-git sometimes hangs on boot
	-dual-core Sony Vaio
Message-ID: <20080415212949.GG1677@cs181133002.pp.htv.fi>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <200804152233.39079.rjw@sisk.pl> <20080415204500.GD1677@cs181133002.pp.htv.fi> <200804152303.45320.rjw@sisk.pl> <924EFEDD5F540B4284297C4DC59F3DEEE17FD4@orsmsx423.amr.corp.intel.com> <1208294294.7851.109.camel@localhost> <924EFEDD5F540B4284297C4DC59F3DEEE17FF1@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEE17FF1@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 02:24:35PM -0700, Pallipadi, Venkatesh wrote:
>...
> >> Both of them probabilistically hang early in the boot.
> >> On both !CPUIDLE and hpet=disable seems to be working around the
> >> problem.
> >> Both are Core 2 Duo based with 64 bit kernel.
> >> 
> >> One difference I saw was that #10377 fails on battery. That may be
> >> because when on battery CPUs may be running at lower freq during boot
> >> and that is probably helping this problem in terms of timing.
> >
> >FWIW, this macbook pro1,1 has only a core 1 duo, so x86 == 32bit...
> >Soeren
> 
> Sorry. When I said Core 2, I was referring to Carlos and his updates on
> #10117.

This bug tracks Soerens problem.

And the fact that Carlos and Mark discuss their different problems in 
the same bug is just plain wrong.

We must learn to more aggressively point people at reporting their 
issues in own bugs, instead of hijacking an already existing similar
looking bug (that might be for a different issue).

Carlos, Mark, can you open own bugs for your issues?

> Thanks,
> Venki

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

