Return-Path: <linux-kernel-owner+w=401wt.eu-S1762623AbXE1KbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762623AbXE1KbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbXE1KbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:31:15 -0400
Received: from styx.suse.cz ([82.119.242.94]:35335 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750985AbXE1KbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:31:14 -0400
Date: Mon, 28 May 2007 12:42:51 +0200
From: Jan Kara <jack@suse.cz>
To: Florin Iucha <florin@iucha.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops in dentry_iput with 2.6.22-rc2 on AMD64
Message-ID: <20070528104251.GB20591@duck.suse.cz>
References: <20070522041036.GD6074@iucha.net> <20070522095711.GB27428@atrey.karlin.mff.cuni.cz> <20070525040752.GB5762@iucha.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525040752.GB5762@iucha.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 24-05-07 23:07:52, Florin Iucha wrote:
> On Tue, May 22, 2007 at 11:57:11AM +0200, Jan Kara wrote:
> > > I was running a multithreaded perl application that leaks some memory
> > > so it gets to eat up a significant chunk of my 2 GB and even push a
> > > bit into swap.  I left it running before going out for a walk.
> >   Hmm, what seems suspitious is, that in R12 (which probably contains
> > the address dereferenced later) is address ffff9100... while all other
> > addresses start with ffff8100. So it seems to me it could be a 1-bit
> > flip. Care to check your memory with memtest?
> 
> I let it run overnight: 8 passes and no surprises.  This is a system
> that has been quite stable for a year and a half, except finding the
> occasional kernel bug ;)
  OK, then it might be some gamma ray hitting your memory :)

> >   Also this is a code all other people use all the time so I guess we
> > would see more reports if this was some general bug...
> 
> Haven't got any more oopses like that, either.
  Hmm, unless you'll see the oops again, it's probably undebuggable...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
