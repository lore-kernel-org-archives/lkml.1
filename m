Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbZGTVAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbZGTVAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbZGTVAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:00:34 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:53838 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZGTVAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:00:25 -0400
Date: Mon, 20 Jul 2009 23:00:16 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ian Molton <spyro@f2s.com>, Anton Vorontsov <cbou@mail.ru>,
       Matt Reimer <mreimer@vpop.net>
Subject: Re: [PATCH 1/3] pda-power: add set_charged functionaltity
Message-ID: <20090720210016.GG19257@buzzloop.caiaq.de>
References: <1247759044-4747-1-git-send-email-daniel@caiaq.de> <20090720182752.GA20602@oksana.dev.rtsoft.ru> <20090720183711.GF19257@buzzloop.caiaq.de> <20090720190034.GA24617@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720190034.GA24617@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 11:00:34PM +0400, Anton Vorontsov wrote:
> > Erm, does it? What would you expect it to do in there?
> 
> Um... then the patch subject is misleading. It says "pda-power".

Well, that's the subsystem it addresses :)

> Is there any user of this new call, btw? I mean a mainline user,
> or soon to be?

No, not yet. We might be merging our platform code mainline some day,
but at the moment it doesn't make sense to anyone to have have it. The
only prototypes tha exist are on our desks :)

Anyway - the surrounding code is perfectly simple. It just registers an
IRQ and calls set_battery_charged() in it. The battery driver cares for
debouncing and the like.

> > Hmm. I thought about that too, but didn't find a way to access the
> > single members of the pda-power device and find the right one to
> > access. They're registered on a string base and matched magically once
> > the battery monitor is probed when found on the one-wire bus. Any
> > proposal how an interface could look like that does that?
> > 
> > All I need is a way to pass this information from my platform code down
> > to the battery driver.
> 
> Yes, I see the problem, but I don't have a solution off-hand. :-/
> 
> Let me think about it for awhile.

So will I :)

> > Thanks. What about the one adding support for the bootstrapping of the
> > current_accum value? I've sent that inline as a reply to the other patch
> > series (4/4) last week (which was probably not a good idea).
> 
> "ds2760: add current_accum module parameter"? Looks perfectly OK.

That one, yes. Thanks for applying.

Daniel
