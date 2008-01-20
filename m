Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbYATLTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbYATLTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 06:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYATLTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 06:19:31 -0500
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:52250 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYATLTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 06:19:30 -0500
Date: Sun, 20 Jan 2008 12:18:40 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>, Chodorenko Michail <misha@one.by>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Celeron Core
In-Reply-To: <20080119042750.GA24481@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0801201216520.28200@anakin>
References: <3ed23423adebae08e8f75b6a6a7ce7ff@one.by> <p73prvyalfl.fsf@bingen.suse.de>
 <1200702477.25782.41.camel@cinder.waste.org> <20080119011506.GA23798@one.firstfloor.org>
 <1200715842.25782.95.camel@cinder.waste.org> <20080119042750.GA24481@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jan 2008, Andi Kleen wrote:
> > So while throttling may be less efficient in terms of watt seconds used
> > to compile something than running at full speed, it is incorrect to say
> > it uses less power. One machine running for an hour throttled to 50%
> > uses less power (and therefore less battery and cooling) than another
> > running at full speed for that same hour.
> 
> Not for the same unit of work. If you just run endless loops you 
> might be true, but most systems don't do that. 

So you mean energy (measured in J).
Power is energy/time unit (measured in W, i.e. J/s).

So I guess what you really want to say is: throttling decreases power
consumption, but on modern CPUs it increases the amount of energy needed
to perform the task.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
