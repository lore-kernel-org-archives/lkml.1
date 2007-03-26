Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbXCZTqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbXCZTqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 15:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbXCZTqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 15:46:40 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35193 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753440AbXCZTqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 15:46:40 -0400
Date: Mon, 26 Mar 2007 21:46:43 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Frederic Riss <frederic.riss@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Message-ID: <20070326194643.GF16477@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070323185022.GQ752@stusta.de> <1174858456.5550.32.camel@funkylaptop> <1174891519.5550.36.camel@funkylaptop> <1174900493.4182.14.camel@chaos> <1174935200.5550.43.camel@funkylaptop> <20070326190233.GE16477@stusta.de> <87d3b2040703261239m3e1dd5depd1884d80157f4a6a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87d3b2040703261239m3e1dd5depd1884d80157f4a6a@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 09:39:29PM +0200, Frederic Riss wrote:
> 2007/3/26, Adrian Bunk <bunk@stusta.de>:
> >On Mon, Mar 26, 2007 at 08:53:20PM +0200, Frédéric Riss wrote:
> >
> >>... (In fact it hangs at the second suspend, but that's another ATA
> >> problem that I think has already been reported).
> >
> >This sounds like the MSI problem.
> >
> >Do you have CONFIG_PCI_MSI enabled?
> >If yes, does disabling it fix it?
> 
> Yes
> 
> >If yes, does CONFIG_PCI_MSI=y with the patch from [1] work?
> 
> Yes !

Thanks for your testing.

> Just to be 100% clear, the hang I was seeing at the second suspend is this 
> one:
> 
> Subject    : second suspend to disk in a row results in an oops  (libata?)
> References : http://lkml.org/lkml/2007/3/17/43
> Submitter  : Thomas Meyer <thomas@m3y3r.de>
> Status     : unknown
> 
> I'm not sure it was associated with the MSI issue yet.

That's what I was calling "the MSI problem".
Since my latest regression list actual cause and patch have been found.

> Thanks a lot,
> Fred
> 
> >[1] http://lkml.org/lkml/2007/3/24/136

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

