Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbXDYWLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbXDYWLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbXDYWLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:11:09 -0400
Received: from mail1.panix.com ([166.84.1.72]:51104 "EHLO mail1.panix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467AbXDYWLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:11:07 -0400
Date: Wed, 25 Apr 2007 15:11:01 -0700 (PDT)
From: Kenneth Crudup <kenny@panix.com>
To: Pavel Machek <pavel@ucw.cz>
cc: Adrian Bunk <bunk@stusta.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070425173405.GE17074@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0704251501550.8406@vaio.localdomain>
References: <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu>
 <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu>
 <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425072350.GA6866@ucw.cz> <20070425151825.GW3468@stusta.de>
 <20070425173405.GE17074@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Apr 2007, Pavel Machek wrote:

> But ... you are really using suspend-to-disk as a workaround for "my
> desktop takes too much power when idle".

While rare is the day admittedly, that my machine isn't on, there are
days I take a break from loooong days and won't work for 2-5 days at
a time.

My main revenue machine is a laptop with a fast, but last-generation
mobile processor and 2GB of DDR2 SDRAM.

I think it's ridiculous to expect that I could resume off battery (and
this thing is a behemoth, with a 17" screen and backlight and a lot of
little juice-eating peripherals that'll go thru a 4.4A/Hr battery in a
little over 90 mins, even with conservative power settings) after that
kind of delay. I don't even like "suspend to RAM, then suspend to disk
on battery low" 'cause that means when I turn it on again I have a low
battery for an hour and a half.

The only acceptable power usage when (completely) idle, IMO, is *zero*.

	-Kenny

-- 
Kenneth R. Crudup  Sr. SW Engineer, Scott County Consulting, Los Angeles
O: 3630 S. Sepulveda Blvd. #138, L.A., CA 90034-6809      (888) 454-8181
