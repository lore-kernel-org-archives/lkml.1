Return-Path: <linux-kernel-owner+w=401wt.eu-S1161833AbXECKu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161833AbXECKu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161826AbXECKu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:50:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52299 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161831AbXECKu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:50:27 -0400
Date: Thu, 3 May 2007 11:50:24 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Michael Schmitz <schmitz@debian.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 04/33] m68k: Atari keyboard and mouse support.
Message-ID: <20070503105024.GA21658@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Michael Schmitz <schmitz@mail.biophys.uni-duesseldorf.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Michael Schmitz <schmitz@debian.org>,
	Roman Zippel <zippel@linux-m68k.org>
References: <20070501203234.252205858@mail.of.borg> <20070501203330.172479999@mail.of.borg> <20070501205740.GC21080@infradead.org> <Pine.LNX.4.58.0705031236150.8342@xplor.biophys.uni-duesseldorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0705031236150.8342@xplor.biophys.uni-duesseldorf.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 12:47:12PM +0200, Michael Schmitz wrote:
> On Tue, 1 May 2007, Christoph Hellwig wrote:
> 
> > What's the reason for splitting this up?  Things would be a quite a bit
> > simpler if all the code was directly in atakeyb.c.
> 
> Simple: I assumed that keeping the input driver code with the other input
> stuff was the Right Thing. I can move everything back to atakeyb.c if
> that's preferred.

I think keeping it all under arch/ makes more sense.  drivers/input/
makes a lot of sense where we have keyboard controllers that are used
on various architectures with slightly different glue, or different
controllers for the same busses.  IF you have really totally architecture
specific input devices that require intimate arch knowledge it probably
makes more sense to keep them there.

> > > +/*
> > > + * linux/atari/atakeyb.c
> 
> Shall I update that path, then? :-)

Just remove it.

