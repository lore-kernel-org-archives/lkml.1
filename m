Return-Path: <linux-kernel-owner+w=401wt.eu-S1759263AbXJLEDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263AbXJLEDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 00:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbXJLEDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 00:03:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45754 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbXJLEDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 00:03:33 -0400
Date: Thu, 11 Oct 2007 21:03:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: David Miller <davem@davemloft.net>, rdreier@cisco.com,
       general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jeff@garzik.org
Subject: Re: [GIT PULL] please pull infiniband.git for-linus
In-Reply-To: <20071012035215.GA10190@suse.de>
Message-ID: <alpine.LFD.0.999.0710112056010.6887@woody.linux-foundation.org>
References: <aday7e9b0m3.fsf@cisco.com> <20071011.181719.78707713.davem@davemloft.net>
 <alpine.LFD.0.999.0710111944120.6887@woody.linux-foundation.org>
 <20071012035215.GA10190@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Oct 2007, Greg KH wrote:

> On Thu, Oct 11, 2007 at 07:58:04PM -0700, Linus Torvalds wrote:
> > 
> > So I merged it all, and I don't expect any problems, but I'm hoping 
> > somebody is thinking about that mod_devicetable.h/file2alias.c mess.
> > 
> > I'm not entirely sure who to blame on that thing. I'm adding Greg to the 
> > Cc, on the assumption that blaming him is usually the right thing to do ;)
> 
> Hey, it wasn't me this time, I haven't even built my trees for you to
> pull from and break everything yet :)

No, I meant more in the "who the hell is responsible for designing those 
*files*" rather than who is responsible for the particular merge mess 
that happened to involve them this time around.

> But yeah, splitting up the mod_devicetable.h/file2alias.c mess is a very
> good idea, I'll see what I can come up with tomorrow.

I don't think it's a huge issue, but I wanted to bring it up because these 
days we're normally so good with these kinds of things that it actually 
stood out a bit. I used to do these kinds of nasty merges all the time 
with init/main.c and the configuration files, until we split them up.

So I'm certainly perfectly able and used to doing them, it's just that I 
also think that we have generally learnt to do so much better.

In other words: no hurry or pressure, I just wanted to bring it up, since 
during the merge I got flashbacks to various "bad old times" that I had 
hoped we had mostly left behind.

Those files were originally designed/set up by Rusty. I could have blamed 
him, or perhaps Sam as a kbuild guy, but the reason I cc'd you is that I 
think this kind of smells like a "device model"ish thing...

Hmm?

		Linus
