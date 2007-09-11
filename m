Return-Path: <linux-kernel-owner+w=401wt.eu-S1762040AbXIKIFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762040AbXIKIFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 04:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbXIKIFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 04:05:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59174 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755962AbXIKIFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 04:05:12 -0400
Date: Tue, 11 Sep 2007 10:05:26 +0200
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Kyle Rose <krose@krose.org>, Bill Davidsen <davidsen@tmr.com>,
       James Corey <ploversegg@yahoo.com>, Rob Sims <lkml-z@robsims.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
Message-ID: <20070911100526.6aa5d463@oldman>
In-Reply-To: <20070909111326.GF3563@stusta.de>
References: <20070905102230.10b0bdcf@oldman>
	<782111.42803.qm@web90413.mail.mud.yahoo.com>
	<46E2DF74.7040307@tmr.com>
	<20070908191132.GD3563@stusta.de>
	<46E35D8C.1070909@krose.org>
	<20070909111326.GF3563@stusta.de>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2007 13:13:26 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> On Sat, Sep 08, 2007 at 10:42:20PM -0400, Kyle Rose wrote:
> > 
> > > You are a regular reader of linux-kernel, and therefore the sk98lin 
> > > removal can hardly be a surprise for you. If you prefer whining over 
> > > helping to improve the kernel that's your choice...
> > >   
> > In my case the issue is simply one of practicality: I cannot go to the
> > data center 5 times per day to reboot my colo box.  Therefore, I run
> > sk98lin.  It's really that simple.
> 
> When did you report this bug the first time?
> 
> What we need is that people when testing a new kernel they plan to use 
> test the new drivers *and report the bugs if they run into any*.
> 
> What could we have done so that you reported your bug without removing 
> the sk98lin driver?
> 
> > Kyle
> 
> cu
> Adrian


There are several different problems in this thread:
1. The removal of old sk98lin driver caused some users to be forced to use
    skge. These users have uncovered issues with the dual port fiber based versions
    of the board.  
    Short term: The sk98lin driver should be restored to previous state, 
       and the PCI table should be used to limit the usage to only fiber systems.
       If Adrian doesn't do it, I'll do it when I return from Germany.
    Long term: I have fiber based board (thanks ebay) on the way to resolve
       skge bug.

2. Sky2 driver has it's own fiber based problems.  Solve these after skge fiber.

3. Sky2 doesn't have as many workarounds for hardware problems as vendor sk98lin
    driver.
