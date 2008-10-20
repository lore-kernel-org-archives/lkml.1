Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYJTUeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYJTUeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbYJTUeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:34:05 -0400
Received: from kroah.org ([198.145.64.141]:59298 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753542AbYJTUeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:34:04 -0400
Date: Mon, 20 Oct 2008 13:30:33 -0700
From: Greg KH <greg@kroah.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Steven Noonan <steven@uplinklabs.net>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081020203033.GB20788@kroah.com>
References: <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com> <20081017174657.GH2221@kroah.com> <20081017204723.15114eaa@lxorguk.ukuu.org.uk> <20081017214409.GB3585@kroah.com> <20081018084504.GQ24654@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081018084504.GQ24654@1wt.eu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 10:45:05AM +0200, Willy Tarreau wrote:
> On Fri, Oct 17, 2008 at 02:44:09PM -0700, Greg KH wrote:
> > On Fri, Oct 17, 2008 at 08:47:23PM +0100, Alan Cox wrote:
> > > > And that's my point here, do we want to change the current numbering
> > > > scheme as people have expressed annoyances of the current one.
> > > 
> > > But any new scheme will be just as annoying to someone and it messes up
> > > existing documentation, understanding and risks breaking third party
> > > tools.
> > > 
> > > Is it really worth the hassle, plus we'll have to change again if we use
> > > date/times because once we are shipping Linux out to Alpha Centauri with
> > > colonists there will be serious problems trying to compute the effect of
> > > tau on release numbering ...
> > 
> > Sure, but by then, the 2.6.521 release will be out and we could fix it
> > up by finally going to 3.0 :)
> > 
> > Seriously, am I the only one that is getting annoyed by our version
> > numbers?  If so, I can live with it, but I got the feeling that I wasn't
> > alone here.
> 
> No you're not. I am too. Maybe we're both more annoyed than majority
> because we're mostly dealing with 4-numbers versions.
> 
> I remember having recently suggested someone to test 2.6.37, doing a
> confusion between 2.4.37 and 2.6.27. I have already tagged kernels
> with wrong versions, having to fix by hand afterwards. It's really
> cumbersome some times.

Yeah, I'm not the only one that has done that then :)

And yes, it is a pain to fix up.

> IMHO, having a small number of small digits is the way to go. Using
> 1 or 2 digits for the major and 1 for the minor is fine. After 3.9, you
> go to version 4.0. Anyway, there are so many changes between versions
> these days that any new versions could justify a major change (eg:
> check the size of the 2.6.27 patch).
> 
> With versions from 1.1 to 9.9, you can go as high as 88 versions,
> which is about 22 years of development at current pace. After that,
> we can simply turn to 10.0 and not break anything.
> 
> It's also easier for users. Check how many non-kernel techies around you
> know all 3 digits of the version they use. It's easier to remember 4.3
> than it is to remember 2.6.27.

I agree that would be nicer, and easier for everyone.

thanks,

greg k-h
