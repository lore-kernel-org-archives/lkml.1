Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYIEQYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYIEQYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYIEQYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:24:47 -0400
Received: from r00tworld.com ([212.85.137.21]:50234 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbYIEQYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:24:46 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Fri, 05 Sep 2008 18:23:38 +0200
MIME-Version: 1.0
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Reply-to: pageexec@freemail.hu
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Message-ID: <48C15D0A.6363.4324231@pageexec.freemail.hu>
In-reply-to: <20080905154221.GF10292@elte.hu>
References: <20080905114233.GA27878@elte.hu>, <48C11F66.18988.341780A@pageexec.freemail.hu>, <20080905154221.GF10292@elte.hu>
X-mailer: Pegasus Mail for Windows (4.50 PB1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Fri, 05 Sep 2008 18:24:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Sep 2008 at 17:42, Ingo Molnar wrote:

> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> 
> > there's that adage about history being repeated by those not knowing it ;)
> > for details see the series based around bypassing Vista's PatchGuard at:
> > 
> >   http://uninformed.org/?v=3
> >   http://uninformed.org/?v=6
> >   http://uninformed.org/?v=8
> 
> i think Linux is fundamentally different here as we have the source 
> code, and could apply the randomization technique i mentioned:

how's that supposed to work for the binary distros, i.e., the majority of
end users? and who would look at all the bugreports from such kernels?

> > > [ It would be nice to have a 'randomize instruction scheduling' 
> > >   option for gcc, to make automated attacks that recognize specific 
> > >   instruction patterns less reliable. ]
> 
> and every box where it matters we could have a _per box_ randomized 
> kernel image in essence, with non-essential symbols thrown away, and 
> with a few checks inserted in random locations - inlined and in essence 
> unrecognizable from the general entropy of randomization.
> 
> Not that a randomizing compiler which inserts true, hard to eliminate 
> entropy would be easy to implement. But once done, the cat and mouse 
> game is over and the needle is hidden in the hay-stack. At least as long 
> as transparent rootkits are involved.
> 
> a successful attack that wants to disable the checks

why do you assume that an attacker wants to do that? it's equally possible,
and there's even academic research on this in addition to the underground
cracking scene, that one simply hides the modifications from the checker.

from marking your patched code as unreadable to executing it from a different
place than what the checker checks, there're many ways to trick such checkers.
as far as reality goes, it's never been game over ;).

