Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbXBFNcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbXBFNcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 08:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbXBFNcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 08:32:25 -0500
Received: from [69.90.0.18] ([69.90.0.18]:56980 "EHLO mtl.rackplans.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbXBFNcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 08:32:24 -0500
Date: Tue, 6 Feb 2007 08:32:21 -0500 (EST)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Ingo Oeser <ioe-lkml@rameria.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <200702052215.01572.ioe-lkml@rameria.de>
Message-ID: <Pine.LNX.4.64.0702060824220.26380@mtl.rackplans.net>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
 <20070205163152.GA2464@elte.hu> <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
 <200702052215.01572.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007, Ingo Oeser wrote:

> On Monday, 5. February 2007, Linus Torvalds wrote:
> > So thank God for the few selects we have, and we should add a whole lot 
> > more!
> 
> But "select" is not fine grained enough.
> 
> I would like to have "require", "recommend", "suggest" for feature A.
> 
> require X
> 	does not work without X, but X is way down the tree 
> 	e.g. ext3 and block device or how select currently is intended
> 
> recommend X
> 	it is usable but uncomfortable without X, enabled per default
> 	e.g. firewalling recommends connection tracking support 
> 	or NAT recommends all NAT helpers
> 
> suggest X
> 	many people use A together with X, 
> 	so you might be interested in enabling it, but I disabled it
> 	per default unless you said "featuritis mode" before.
> 	e.g. highmem and SMP or a network driver and NAPI.
> 
> That is what the Debian/Ubuntu package management does and maybe other too.
> And this also gives us new keywords to replace select with, 
> so migration is doable :-)
> 
> This would also make "EMBEDDED" superflous, because it would just mean 
> "disable anything not required". 
> 
> And this would enable an individual tree for the users current configuration 
> problem instead of a global one.

I think "package manager" is the best possible way to think about this 
problem.

I can't tell you how often I've wished the kernel config process behaved 
like apt and just prompted me with a list of things it would need to 
enable to allow me to use the option and ask me if I still want to do it. 
The reverse when I try and remove something important would be good too 
just ask me if I really want to remove all those as well.

A functional equivelant of deborphan would be cool too.  Just run it and 
have it tell me what is enabled that no devices depend on.

The config system is nasty even for power users. There is a fun part of 
the netfilter code where I find myself having to enable all from one menu, 
go to the next menu down enable everything and then go back to the first 
menu.

	Gerhard


--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
