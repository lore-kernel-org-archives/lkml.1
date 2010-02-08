Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab0BHVRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 16:17:23 -0500
Received: from www.tglx.de ([62.245.132.106]:59999 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab0BHVRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 16:17:22 -0500
Date: Mon, 8 Feb 2010 22:16:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Mohr <andi@lisas.de>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksource mutex deadlock, cat current_clocksource
 (2.6.33-rc6/7)
In-Reply-To: <20100208210219.GA22039@rhlx01.hs-esslingen.de>
Message-ID: <alpine.LFD.2.00.1002082213500.2811@localhost.localdomain>
References: <alpine.LFD.2.00.1002061534020.2811@localhost.localdomain> <20100207191949.GA23665@rhlx01.hs-esslingen.de> <20100208053830.GA7128@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081010330.2811@localhost.localdomain> <20100208093719.GA15428@rhlx01.hs-esslingen.de>
 <alpine.LFD.2.00.1002081038430.2811@localhost.localdomain> <20100208194734.GA20316@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002082117210.2811@localhost.localdomain> <alpine.LFD.2.00.1002082139360.2811@localhost.localdomain> <20100208205105.GA16990@rhlx01.hs-esslingen.de>
 <20100208210219.GA22039@rhlx01.hs-esslingen.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Feb 2010, Andreas Mohr wrote:

> On Mon, Feb 08, 2010 at 09:51:05PM +0100, Andreas Mohr wrote:
> > Looks like it:
> > - another bootup also had lockup message
> > - all /var/log/dmesg* have lockup message, oldest is:
> > 2010-02-07 20:00 dmesg.4.gz
> > 
> > Linux version 2.6.33-rc6 (root@note) (gcc version 4.3.4 (Debian 4.3.4-6)) #3 Sun Jan 31 23:47:51 CET 2010
> 
> -rc4 and 2.6.32.3 don't show lockup message, instant bootup without any
> visible delay.
> 
> Don't tell me I'm now supposed to try -rc5 and also rebuild -rc6 ;)
> If so, do tell early so that I have lots of time to get it built...

Well, we better know, after which point that problem manifested
itself. A bisect would be optimal.

Thanks,

	tglx


