Return-Path: <linux-kernel-owner+w=401wt.eu-S934639AbXGKWne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934639AbXGKWne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762863AbXGKWnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:43:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46633 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762529AbXGKWnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:43:24 -0400
Date: Thu, 12 Jul 2007 00:43:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Martin Orr <martin@martinorr.name>,
       Stefano Rivoir <s.rivoir@gts.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
Message-ID: <20070711224322.GC25510@one.firstfloor.org>
References: <4693327E.6000006@gts.it> <alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org> <46947ADF.4080605@gts.it> <p73vecrxf0t.fsf@bingen.suse.de> <46951892.20406@martinorr.name> <alpine.LFD.0.999.0707111059200.3412@woody.linux-foundation.org> <469544D3.90004@martinorr.name> <alpine.LFD.0.999.0707111410430.20061@woody.linux-foundation.org> <20070711221626.GA25510@one.firstfloor.org> <alpine.LFD.0.999.0707111534340.20061@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707111534340.20061@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 03:37:41PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 12 Jul 2007, Andi Kleen wrote:
> >
> > I just checked with today's gcc 4.2 (070711) freshly compiled and from a quick inspection 
> > the code looks correct again. So perhaps it has been already fixed? 
> 
> Did you see the breakage with the original compiler? It might be some 

No, i don't have a debian compiler and i normally use gcc 4.1 on my
workstation.

BTW I just heard that at least one package in suse STABLE (using a slightly 
older gcc 4.2 snapshot) apprently with inline assembly got miscompiled too

> config setup or something.
> 
> But yeah, if Debian/sid is just using random compiler snapshots of the 
> day, I htink we can just bury this as "pointless".
> 
> Who the heck takes a compiler snapshot and runs with it? At least when 
> your kernel breaks, it seldom breaks subtly (but I would expect that most 
> distros would not pick random nightly kernel builds). When your compiler 
> breaks, you have random problems in totally unexpected places, the last 
> thing you want to have is a random nightly snapshot in a distro - even a 
> development one.

I guess it's because gcc 4.2 is technically supposed to be a -stable tree.

Also recompiling whole distros tends to find a lot of compiler bugs so
I guess it's useful QA for them.

-Andi
