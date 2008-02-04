Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbYBDWsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbYBDWsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbYBDWsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:48:08 -0500
Received: from twin.jikos.cz ([213.151.79.26]:33673 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906AbYBDWsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:48:07 -0500
Date: Mon, 4 Feb 2008 23:48:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Abel Bernabeu <abel.bernabeu@gmail.com>
cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: brk randomization breaks columns
In-Reply-To: <15577be70802041354s23e5b289w56f724dfdf8c3242@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802042346020.30873@twin.jikos.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <20080204130156.GA8730@elte.hu>
  <Pine.LNX.4.64.0802041528470.30955@jikos.suse.cz> 
 <Pine.LNX.4.64.0802041635000.30955@jikos.suse.cz> 
 <15577be70802041016m97cddbfk43b9073408bcbce9@mail.gmail.com> 
 <15577be70802041029o2975ba6do34589bbdc81d1652@mail.gmail.com> 
 <20080204195251.GB4915@elf.ucw.cz> <15577be70802041354s23e5b289w56f724dfdf8c3242@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008, Abel Bernabeu wrote:

> > > I think I am getting the some problem with brand new binaries produced
> > > by myself :(
> > > Look at this report I posted days ago:
> > > http://marc.info/?l=linux-kernel&m=120169141603789&w=2
> > Your crash is in kernel, no? Anyway, I can workaround mine by 
> > disabling randomization...
> Yes, my crash happens at kernel space, but is due to the randomized 
> params passed to set_brk (the same thing that makes your game crash 
> later at runtime).

[ please don't drop me from CC, thanks ]

Abel, I actually don't think you have chance to have any issues with 
randomization, as the mentioned post talks about 2.6.22.10, which doesn't 
randomize the brk start at all.

Thanks,

-- 
Jiri Kosina
SUSE Labs

