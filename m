Return-Path: <linux-kernel-owner+w=401wt.eu-S932276AbYAaKjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbYAaKjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765651AbYAaKim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:38:42 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:33188 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759858AbYAaKil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:38:41 -0500
Date: Thu, 31 Jan 2008 11:38:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: about relocs.c on x86
Message-ID: <20080131103842.GA550@uranus.ravnborg.org>
References: <86802c440801310007oe8693c7q177d41a87c27ca7@mail.gmail.com> <20080131095223.GA11867@elte.hu> <1201773740.23523.17.camel@brick> <20080131101111.GB11867@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131101111.GB11867@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> no strong opinion from me - but i think it should be obvious to the 
> developer when they are looking at a .c file that it's 32-bit only (or 
> 64-bit only). I.e. the default is that whatever .c file we look at is 
> unified - and in that sense relocs.c breaks that general expectation.

I for one would like to see when stuff is 32 bit only and when
shared across 32 and 64 bit. 
And this type of info is useful when I do greps so hiding the information
in a Makefiel is then no good.

It helps your understanding when you get the most correct picture of
where a certain symbol is used - a functionality I often need.
And this is by no menas limited to a narrow x86 view but across
the full kernel.

So I, and this is no news for Ingo, would like to see what is
solely for 32 bit to be marked as such.

And we are heading with full speed to the situation for x86 where
the number of foo_32.c, foo_64.c are minimal.
But that said we will likely see a small decrease in speed now.

As for the Makefiles - I looked at them last time and only
issue that kept me away for unifying them was that I did
not understand the linking order requirments and I did not see
enough benefit at that time to invest the time to unify them.
Each of the remaining Makefile should be unifyable in less
than 10 steps each. It is just work that are waitng to be done.

	Sam
