Return-Path: <linux-kernel-owner+w=401wt.eu-S964883AbXGLAN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883AbXGLAN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935882AbXGLAHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:07:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53691 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935874AbXGLAHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:07:22 -0400
Date: Thu, 12 Jul 2007 02:07:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-ID: <20070712000720.GA26585@one.firstfloor.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org> <1184191488.12353.160.camel@chaos> <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org> <1184194219.12353.170.camel@chaos> <alpine.LFD.0.999.0707111558250.20061@woody.linux-foundation.org> <20070711233618.GD25510@one.firstfloor.org> <20070711235852.GA625@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711235852.GA625@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> i dont think "clean, modern x86 code" will ever happen - x86_64 has and 
> is going to have the exact same type of crap. And i'll say a weird thing 

Yes, but it will be new crap, but no old crap anymore.

If you always pile the new crap on the old crap at some point
the whole thing might fall over. 64bit was intended as a fresh start.

Admittedly we're getting more and more workarounds too and sometimes
when I want to remove cruft i find out it is still needed on some
64bit boxes (e.g. see my repeated attempts to clean up the irq 0
routing), but it's still much better than i386.

> I think the PowerPC experience (although it is not a fully equivalent 
> case) about them merging their 32-bit and 64-bit architectures was an 
> overwhelmingly positive move, and x86 could learn a thing or two from 
> that.

The equivalent to the powerpc way would be essentially to report i386
into the x86-64 code base and leave the really old hardware only
in arch/i386. I've considered doing it, but it would be an awful
lot of work and to tempt distributions to actually use the new
port would require going back quite a long time. And at least
immediately it would end up with three cases to do things instead
of two like currently.

-Andi

