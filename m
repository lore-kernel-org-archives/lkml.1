Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbYHYThU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbYHYThU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 15:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYHYThH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 15:37:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38606 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbYHYThG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 15:37:06 -0400
Date: Mon, 25 Aug 2008 21:39:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123 send_IPI_mask_bitmask+0xc3/0xe0()
Message-ID: <20080825193926.GF26610@one.firstfloor.org>
References: <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com> <20080822003659.GA7581@redhat.com> <48AE20B8.9000204@kernel.org> <19f34abd0808240220v77bcdd5di32f8f865b18fc49f@mail.gmail.com> <48B19799.6090703@kernel.org> <19f34abd0808241022j1ab6f3e6qd72b9acba5df4892@mail.gmail.com> <19f34abd0808241045r37eb8661h3cc688b6f0513777@mail.gmail.com> <20080824181304.GA5963@redhat.com> <20080825183611.GE26610@one.firstfloor.org> <20080825185450.GD11894@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825185450.GD11894@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 02:54:51PM -0400, Dave Jones wrote:
> On Mon, Aug 25, 2008 at 08:36:11PM +0200, Andi Kleen wrote:
>  > > Probably because you're using p4-clockmod, and it's crap.
>  > 
>  > Really should really bite the bullet and just remove it. People 
>  > run in this all the time and I bet you can count the people who
>  > actually use it consciously and usefully with one hand.
>  > 
>  > Or at least only make it run when the user set a "I_REALLY_KNOW_WHAT_I_AM_DOING"
>  > option explicitely.
> 
> We can't really remove it until ACPI processor driver has a better
> response than 'thermal event, argh!, shut down'.

It only does that when the critical trip point is reached (which
basically means that the BIOS tells it -- "I'm on fire"). What else should 
it do in your opinion when this happens?

-Andi
