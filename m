Return-Path: <linux-kernel-owner+w=401wt.eu-S934044AbXGKWi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044AbXGKWi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbXGKWiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:38:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41941 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753378AbXGKWiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:38:13 -0400
Date: Wed, 11 Jul 2007 15:37:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Martin Orr <martin@martinorr.name>, Stefano Rivoir <s.rivoir@gts.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
In-Reply-To: <20070711221626.GA25510@one.firstfloor.org>
Message-ID: <alpine.LFD.0.999.0707111534340.20061@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
 <4693327E.6000006@gts.it> <alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org>
 <46947ADF.4080605@gts.it> <p73vecrxf0t.fsf@bingen.suse.de>
 <46951892.20406@martinorr.name> <alpine.LFD.0.999.0707111059200.3412@woody.linux-foundation.org>
 <469544D3.90004@martinorr.name> <alpine.LFD.0.999.0707111410430.20061@woody.linux-foundation.org>
 <20070711221626.GA25510@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Jul 2007, Andi Kleen wrote:
>
> I just checked with today's gcc 4.2 (070711) freshly compiled and from a quick inspection 
> the code looks correct again. So perhaps it has been already fixed? 

Did you see the breakage with the original compiler? It might be some 
config setup or something.

But yeah, if Debian/sid is just using random compiler snapshots of the 
day, I htink we can just bury this as "pointless".

Who the heck takes a compiler snapshot and runs with it? At least when 
your kernel breaks, it seldom breaks subtly (but I would expect that most 
distros would not pick random nightly kernel builds). When your compiler 
breaks, you have random problems in totally unexpected places, the last 
thing you want to have is a random nightly snapshot in a distro - even a 
development one.

Strange.

		Linus
