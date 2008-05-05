Return-Path: <linux-kernel-owner+w=401wt.eu-S1750879AbYEEEUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750879AbYEEEUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 00:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbYEEET4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 00:19:56 -0400
Received: from ns.suse.de ([195.135.220.2]:51924 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbYEEET4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 00:19:56 -0400
Date: Mon, 5 May 2008 06:19:54 +0200
From: Nick Piggin <npiggin@suse.de>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nopage mm.h
Message-ID: <20080505041954.GB17640@wotan.suse.de>
References: <dd18b0c30805031629x5f570b97q43f110b228054a28@mail.gmail.com> <481D68E0.1040608@gmail.com> <dd18b0c30805040912l2d12115bi3987d8a5ed0372bf@mail.gmail.com> <20080505032843.GA14947@wotan.suse.de> <dd18b0c30805042047h79f1e025s51037d05e09e7fdb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30805042047h79f1e025s51037d05e09e7fdb@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 03:47:27AM +0000, Justin Mattock wrote:
> On Mon, May 5, 2008 at 3:28 AM, Nick Piggin <npiggin@suse.de> wrote:
> > On Sun, May 04, 2008 at 04:12:49PM +0000, Justin Mattock wrote:
> >  > On Sun, May 4, 2008 at 7:42 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> >  > > Justin Mattock napsal(a):
> >  > >
> >  > > > Hello; I have a question about the nopage function that was removed in
> >  > > > the kernel.
> >  > > > What would be the best way for me to build a module that has a nopage
> >  > > > funtion in it?
> >  > > >
> >  > >
> >  > >  use .fault instead
> >  > >
> >  > Hello thanks for the response, I'll have a look into that. The problem
> >  > I'm confronted with right now is the module is not going to
> >  > install due to it being a non-GPL module. After doing some reading I
> >  > was unawre that the kernel was going GPL-only in 2008, so with that in
> >  > mind I need to comply with the regulations. So the question I have now
> >  > is: Is there a module that is GPL approved that will give me 3D for
> >  > the macbook pro. And also recover from suspend?
> >
> >  Hopefully the driver vendor should provide an update soon. Otherwise,
> >  possibly you could patch back in the .nopage stuff? (It is just a
> >  single commit which does nothing but remove nopage, try reverting it).
> >
> >
> >
> 
> Hello; thanks for the info, I did revert the nopage back into the
> kernel, but after all of that, I'm confronted with
> the module not being a GPL-only module  `init_pid_ns'.
> I've looked in kernel/pid.c and am noticing  EXPORT_SYMBOL_GPL(init_pid_ns);
> With that in mind I'm more concerned about the module not being
> GPL-only, is this in full enforcement, or just a thaught
> that irritated a bunch of people.
> regards;

OK, not sure about that one... but if it is just your personal kernel,
and not for redistribution, then you are of course free to make any
changes you like. Including changing EXPORT_SYMBOL_GPL. Maybe it is
a reasonable temporary measure for you until you get some better
drivers.

