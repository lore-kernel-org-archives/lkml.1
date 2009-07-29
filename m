Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbZG2ANp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbZG2ANp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZG2ANo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 20:13:44 -0400
Received: from kroah.org ([198.145.64.141]:41339 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbZG2ANn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 20:13:43 -0400
Date: Tue, 28 Jul 2009 17:12:52 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090729001252.GA23526@kroah.com>
References: <20090728180649.596c5412@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907281141070.3186@localhost.localdomain>
 <20090728195651.3a402a31@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907281158120.3186@localhost.localdomain>
 <20090728201553.0eb2d51d@lxorguk.ukuu.org.uk>
 <20090728195648.GA4833@kroah.com>
 <20090728204720.GF31679@mit.edu>
 <20090728210121.GB12155@kroah.com>
 <20090728220203.GI31679@mit.edu>
 <20090729004941.3a78d4b3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729004941.3a78d4b3@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 12:49:41AM +0100, Alan Cox wrote:
> On Tue, 28 Jul 2009 18:02:03 -0400
> Theodore Tso <tytso@mit.edu> wrote:
> 
> > On Tue, Jul 28, 2009 at 02:01:21PM -0700, Greg KH wrote:
> > > On Tue, Jul 28, 2009 at 04:47:20PM -0400, Theodore Tso wrote:
> > > > On Tue, Jul 28, 2009 at 12:56:48PM -0700, Greg KH wrote:
> > > > > 
> > > > > Do you have a pointer to your previous queue before you zapped it so
> > > > > that others might be able to pick it up?
> > > > > 
> > > > 
> > > > It's also available from linux-next as commit:
> > > > 
> > > >      024ea7873598686f3e02002ca23c2e8fa3fddd30
> > > 
> > > Hm, that's the wrong end of the tree, I think you mean
> > > fbfa97a856a4ce2fa86058cff84f589eb7f1364e, right?
> > 
> > It all depends on your point of view, I guess.  The "last" commit in
> > the branch is 024ea78, so you can see the whole queue if you use the
> > command "git log 024ea78"; hence, it's the most useful if you're
> > trying to find the patch series via git.
> > 
> > The whole set of tty patches can be found via:
> > 
> > git log e00b95d..024ea78
> > 
> > (where e00b95d is the parent of fbfa978).
> 
> I'll fish them out tomorrow. What is in the -next tree is only some of
> the bits.
> 
> We still have races on the USB side too btw I put a frequency generator
> on the carrier line of my pl2303 with an app continually opening the
> port and it oopses after about 10 minutes. On the bright side so does
> 2.6.29, 2.6.27 ....

Yeah, that's a scary test :)

I've gotten everything from linux-next right now, if you could be so
kind as to send me the rest of the bits you have pending, I'll be glad
to take them over and shephard them forward over time.

thanks,

greg k-h
