Return-Path: <linux-kernel-owner+w=401wt.eu-S1763386AbYEGWaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763386AbYEGWaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYEGW2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:28:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:50683 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933332AbYEGW2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:28:51 -0400
Date: Thu, 8 May 2008 00:29:37 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Adrian Bunk <bunk@kernel.org>, Rene Herman <rene.herman@keyaccess.nl>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: 2.6.26, PAT and AMD family 6
Message-ID: <20080507222937.GI18516@elf.ucw.cz>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl> <alpine.LFD.1.10.0805072315360.3318@apollo.tec.linutronix.de> <20080507214646.GC14951@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072354450.3318@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805072354450.3318@apollo.tec.linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > His commit ***added*** the three copies of the same code.
> 
> And you are not able to ******look******* over the brim of your tea
> cup and accept that one of them is 64 bit and the others are a tribute
> to the not yet distangled shit. There would have been a cleaner and
> better way to solve this, but there is always a better and cleaner way
> to do things.

Existing code being a mess is not an excuse for messing it up a bit
more. Which is exactly what Yinghai did.

> Why dont you send a cleanup patch which fixes the three copies problem
> instead of spending your time with writing up ivory tower pieces of
> wisdom ?

Because no ammount of cleanup patches will solve "Ingo did not even
notice missing changelog, and 2 NAKs"?

commit 9307cacad0dfe3749f00303125c6f7f0523e5616 
tree bc28bf08dc18dacbb2654a9a368f4e09c580dfab 
parent a7c7d0e91daebd7c5e51f9416d612b6a15e7e79a 
author Yinghai Lu <yhlu.kernel.send@gmail.com> Mon, 24 Mar 2008 23:24:34 -0700 
committer Ingo Molnar <mingo@elte.hu> Thu, 17 Apr 2008 17:41:20 +0200 

    x86: pat cpu feature bit setting for known cpus
    
    Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
