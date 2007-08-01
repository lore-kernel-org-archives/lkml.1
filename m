Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbXHAERh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbXHAERh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 00:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbXHAERa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 00:17:30 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2379 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbXHAER3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 00:17:29 -0400
Date: Wed, 1 Aug 2007 06:17:29 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: jos poortvliet <jos@mijnkamer.nl>, ck@vds.kolivas.org,
       Michael Chang <thenewme91@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: Linus 2.6.23-rc1
In-Reply-To: <alpine.LFD.0.999.0707281313570.3442@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708010539230.1818@scrub.home>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
 <200707282003.45142.jos@mijnkamer.nl> <alpine.LFD.0.999.0707281109120.3442@woody.linux-foundation.org>
 <200707282128.39906.jos@mijnkamer.nl> <alpine.LFD.0.999.0707281313570.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 28 Jul 2007, Linus Torvalds wrote:

> We've had people go with a splash before. Quite frankly, the current 
> scheduler situation looks very much like the CML2 situation. Anybody 
> remember that? The developer there also got rejected, the improvement was 
> made differently (and much more in line with existing practices and 
> maintainership), and life went on. Eric Raymond, however, left with a 
> splash.

Since I was directly involved I'd like to point out a key difference.

http://lkml.org/lkml/2002/2/21/57 was the very first start of Kconfig and 
initially I didn't plan on writing a new config system. At the beginning 
there was only the converter, which I did to address the issue that Eric 
created a complete new and different config database, so the converter was 
meant to create a more acceptable transition path. What happened next is 
that I haven't got a single response from Eric, so I continued hacking on 
it until was complete.

The key difference is now that Eric refused the offered help, while Con 
was refused the help he needed to get his work integrated.

When Ingo posted his rewrite http://lkml.org/lkml/2007/4/13/180, Con had 
already pretty much lost. I have no doubt that Ingo can quickly transform 
an idea into working code and I would've been very surprised if he 
wouldn't be able to turn it into something technically superior. When Ingo 
figured out how to implement fair scheduling in a better way, he didn't 
use this idea to help Con to improve his work. He decided instead to 
work against Con and started his own rewrite, this is of course his right 
to do, but then he should also accept the responsibility that Con felt his 
years of work ripped apart and in vain and we have now lost a developer 
who tried to address things from a different perspective.

bye, Roman
