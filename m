Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbZDLRap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbZDLRap (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 13:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZDLRae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 13:30:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53040 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbZDLRae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 13:30:34 -0400
Date: Sun, 12 Apr 2009 19:30:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, josh@freedesktop.org
Subject: Re: [PATCH -tip] x86: acpi/sleep.c saved_magic fix overflow
Message-ID: <20090412173009.GA25788@elte.hu>
References: <1239385015.3169.15.camel@ht.satnam> <1239392981.5943.1.camel@localhost.localdomain> <20090410201504.GA23364@elf.ucw.cz> <200904121925.59814.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904121925.59814.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Friday 10 April 2009, Pavel Machek wrote:
> > On Sat 2009-04-11 01:19:41, Jaswinder Singh Rajput wrote:
> > > On Fri, 2009-04-10 at 21:29 +0200, Sam Ravnborg wrote:
> > > > On Sat, Apr 11, 2009 at 12:46:56AM +0530, Jaswinder Singh Rajput wrote:
> > > > > Sorry, I was confused by this sparse warning on 64 bit box:
> > > > > 
> > > > > CHECK   arch/x86/kernel/acpi/sleep.c
> > > > >  arch/x86/kernel/acpi/sleep.c:107:16: warning: constant 0x123456789abcdef0 is so big it is long
> > > > > 
> > > > > atleast I found problem in sparse ;-)
> > > > 
> > > > Sparse tells you that the constant is so big it is long - correct.
> > > > So rather than being implicit appending an L would make sparse happy.
> > > > 
> > > > So please use the constant 0x123456789abcdef0L and I think sparse is silenced.
> > > > And code/functionality is the same.
> > > > 
> > > 
> > > Yes, this fixes the sparse warning, Thanks :-)
> > 
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> 
> OK
> 
> Ingo, are you going to take it or should I handle it?

Sure, feel free to take it - thanks.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
