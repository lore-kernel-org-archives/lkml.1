Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbYIEODx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbYIEODx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbYIEODp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:03:45 -0400
Received: from www.tglx.de ([62.245.132.106]:45101 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbYIEODo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:03:44 -0400
Date: Fri, 5 Sep 2008 16:03:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert commit e8aa4667baf74dfd85fbaab86861465acb811085
In-Reply-To: <20080905124203.GD6743@alberich.amd.com>
Message-ID: <alpine.LFD.1.10.0809051600370.3243@apollo.tec.linutronix.de>
References: <20080904144657.GC15987@alberich.amd.com> <20080904153206.GB7120@elte.hu> <alpine.LFD.1.10.0809041812450.3243@apollo.tec.linutronix.de> <20080905124203.GD6743@alberich.amd.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008, Andreas Herrmann wrote:
> > Is the HPET on these systems not working at all so the force enable
> > code is useless ?
> 
> The current quirk is incomplete. Some more chipset fiddling has to be
> done to enable HPET interrupts. I have a patch that would do this.
> And from my tests it seems to work faultlessly.
> 
> But the official statement is that HPET is not supported on SB4XX.
> 
> Thus there are 2 alternatives:
> (1) Remove the current (incomplete) quirk.
> (2) Extent the quirk.
>     But whoever forces HPET would use it on his own risk.
> 
> I decided to do (1) because it's safest.
> Other opinions?

Yup, I prefer (2). It might help users. It still needs hpet=force on
the kernel command line. So it's a documented "you forced it" feature
with no guarantees.

I don't expect that the systems will explode, burn out or fall into
pieces when hpet is enabled. That would be a reason to go for (1) :)

Thanks,

	tglx
