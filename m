Return-Path: <linux-kernel-owner+w=401wt.eu-S1765264AbYEGVsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765264AbYEGVsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755803AbYEGVsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:48:20 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:56796 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757902AbYEGVsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:48:17 -0400
Date: Thu, 8 May 2008 00:46:46 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
Message-ID: <20080507214646.GC14951@cs181133002.pp.htv.fi>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl> <alpine.LFD.1.10.0805072315360.3318@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805072315360.3318@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 11:41:04PM +0200, Thomas Gleixner wrote:
> On Wed, 7 May 2008, Rene Herman wrote:
> > On 07-05-08 22:52, Thomas Gleixner wrote:
>...
> > > > And this patch (by the author of the code himself) is the first time where
> > > > it breaks.
> > > 
> > > Very interesting analysis. What broke ? This CPU was never in the set
> > > of supported ones at all.
> > 
> > You misunderstood. Yinghai's patch only changed one of the code sites
> > and not the others, which (if I understood right) is the breakage
> > Adrian was reffering to.
> 
> I know exactly what he was referring to. So what's the problem ?
> 
> Yinghai missed to add it to the other place and he is hardly to blame
> for that. This code is messy and thats not his fault. It will be
> cleaned up, but that's not an simple taks to do. If you think you can
> do it without breaking tons of systems, you're welcome.

It actually is completely his fault.

His commit ***added*** the three copies of the same code.

And Pavel did complain about it when it was sent to linux-kernel.

>...
> Thanks,
> 
> 	tglx

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

