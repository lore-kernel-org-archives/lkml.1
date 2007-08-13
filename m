Return-Path: <linux-kernel-owner+w=401wt.eu-S945661AbXHMMv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945661AbXHMMv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940672AbXHMHk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:40:29 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:57289 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S942348AbXHMHkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:40:25 -0400
Date: Mon, 13 Aug 2007 09:39:55 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Snook <csnook@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Luck, Tony" <tony.luck@intel.com>, Andreas Schwab <schwab@suse.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com
Subject: Re: [PATCH 9/24] make atomic_read() behave consistently on ia64
In-Reply-To: <46BFFA71.4080601@redhat.com>
Message-ID: <Pine.LNX.4.64.0708130939470.16526@anakin>
References: <20070809135107.GA15985@shell.boston.redhat.com>
 <617E1C2C70743745A92448908E030B2A02213B3C@scsmsx411.amr.corp.intel.com>
 <46BCC1AF.5050204@redhat.com> <617E1C2C70743745A92448908E030B2A0224C777@scsmsx411.amr.corp.intel.com>
 <jewsw3oyl8.fsf@sykes.suse.de> <617E1C2C70743745A92448908E030B2A0224C88B@scsmsx411.amr.corp.intel.com>
 <46BCE9F8.4060009@redhat.com> <617E1C2C70743745A92448908E030B2A0224C8D7@scsmsx411.amr.corp.intel.com>
 <alpine.LFD.0.999.0708101607130.30176@woody.linux-foundation.org>
 <46BCF19E.5000702@redhat.com> <18109.1084.917429.585224@cargo.ozlabs.ibm.com>
 <46BFFA71.4080601@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Chris Snook wrote:
> Paul Mackerras wrote:
> > Chris Snook writes:
> > > I'll do this for the whole patchset.  Stay tuned for the resubmit.
> > 
> > Could you incorporate Segher's patch to turn atomic_{read,set} into
> > asm on powerpc?  Segher claims that using asm is really the only
> > reliable way to ensure that gcc does what we want, and he seems to
> > have a point.
> > 
> > Paul.
> 
> I haven't seen a patch yet.  I'm going to resubmit with inline volatile-cast
> atomic[64]_[read|set] on all architectures as a reference point, and if anyone
> wants to go and implement some of them in assembly, that's between them and
> the relevant arch maintainers.  I have no problem with (someone else) doing it
> in assembly.  I just don't think it's necessary and won't let it hold up the
> effort to get consistent behavior on all architectures.

http://lkml.org/lkml/2007/8/10/470

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
