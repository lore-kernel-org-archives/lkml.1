Return-Path: <linux-kernel-owner+w=401wt.eu-S1765584AbYBANa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765584AbYBANa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760042AbYBANav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:30:51 -0500
Received: from nelson.telenet-ops.be ([195.130.133.66]:51107 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759072AbYBANau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:30:50 -0500
Date: Fri, 1 Feb 2008 14:30:44 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Are Section mismatches out of control?
In-Reply-To: <1201864894.23523.117.camel@brick>
Message-ID: <Pine.LNX.4.64.0802011325080.18111@anakin>
References: <20080201104718.GA11717@uranus.ravnborg.org>
 <20080201030329.9b760777.akpm@linux-foundation.org> <1201864894.23523.117.camel@brick>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008, Harvey Harrison wrote:
> On Fri, 2008-02-01 at 03:03 -0800, Andrew Morton wrote:
> > On Fri, 1 Feb 2008 11:47:18 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:
> > > James said in a related posting that the Section mismatch
> > > warnings were getting out of control.
> > 
> > eh.  They're easy - the build system tells you about them!
> > 
> > > The list is here:
> > 
> > Question is: why do people keep adding new ones when they are so easy to
> > detect and fix?
> > 
> > Asnwer: because neither they nor their patch integrators are doing adequate
> > compilation testing.
> 
> Because if there already exists more than a handful peoples' eyes glaze
> over and ignore "just one more warning"

Yes.

> Unless they break the build, or if there currently are 0 and they make
> it non-zero, people seem not to care....sad.  Probably the same for
> sparse/checkpatch, "there's plenty already, I can't be bothered to look"

And before, the actual warnings depended a lot on the kernel
configuration, so making the build break was less of an option.
If Sam's improved section mismatch detection turns out to work fine, we
can fix the issues and start to enable breaking of the build in case of
warnings.

BTW, on m68k I get ca. 160 of them. Most seem to originate in
drivers/isdn/. Doesn't look unsurmountable compared to the number of
other compile warnings fixed during the last few years ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
