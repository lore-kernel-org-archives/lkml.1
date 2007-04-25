Return-Path: <linux-kernel-owner+w=401wt.eu-S2992922AbXDYSxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992922AbXDYSxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992927AbXDYSxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:53:07 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992922AbXDYSxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:53:05 -0400
Date: Wed, 25 Apr 2007 11:50:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070425183934.GX3468@stusta.de>
Message-ID: <alpine.LFD.0.98.0704251148110.9964@woody.linux-foundation.org>
References: <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net>
 <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425072350.GA6866@ucw.cz> <20070425151825.GW3468@stusta.de>
 <20070425173405.GE17074@elf.ucw.cz> <20070425183934.GX3468@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Apr 2007, Adrian Bunk wrote:
> 
> 3W for the complete system? In CPU state S1? [1]

In STR, 3W is quite realistic. The CPU is off, all (or most - up to you) 
the devices are off, but the motherboard and memory is powered.

> And even 3W would still be a waste of energy.

.. but if the alternative is a feature that just isn't worth it, and 
likely to not only have its own bugs, but cause bugs elsewhere? (And yes, 
I believe STD is both of those. There's a reason it's called "STD". Go 
to google and type "STD" and press "I'm feeling lucky". Google is God).

		Linus
