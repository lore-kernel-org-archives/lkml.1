Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbZDORXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbZDORXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 13:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbZDORXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 13:23:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704AbZDORXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 13:23:39 -0400
Date: Wed, 15 Apr 2009 10:19:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
In-Reply-To: <20090415162627.GA32254@elte.hu>
Message-ID: <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <20090414020544.GA3738@elte.hu> <20090415054417.GA5272@elte.hu> <200904152014.11717.rusty@rustcorp.com.au> <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain> <20090415162627.GA32254@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Apr 2009, Ingo Molnar wrote:
> 
> We are using impact lines to judge "practical impact of a commit". 
> The shorter (while still correct and expressive), the better. We are 
> trying to use it in well-defined cases - but not always.

The thing is, I've seen totally bogus "Impact:" statements.

It just makes things look more official, without actually guaranteeing 
that it's any more correct. For example, I've seen impact statements to 
the effect of "cleanup", when (a) it wasn't and (b) it did other things 
too.

At that point, it's just distraction and wrong.

And in fact, "cleanup" seems to be the most common one. Along with other 
totally useless ones like "fix build" or just "Fix" .

Gaah. 

Doing a

	git log -p --grep=Impact:.*lean 

shows several "cleanuips" that are anything but. Those "cleanups" fix 
build errors or actually change code. The "Impact:" statement is actively 
misleading, adds absolutely _nothing_, and detracts from the real issue 
and the real message.

			Linus
