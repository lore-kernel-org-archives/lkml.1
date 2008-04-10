Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbYDJNw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbYDJNw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 09:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbYDJNwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 09:52:18 -0400
Received: from mtl.rackplans.net ([69.90.0.18]:40908 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756AbYDJNwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 09:52:17 -0400
Date: Thu, 10 Apr 2008 09:52:16 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Mark Lord <lkml@rtr.ca>, David Miller <davem@davemloft.net>,
       yoshfuji@linux-ipv6.org, jeff@garzik.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
In-Reply-To: <1207787848.16220.25.camel@brick>
Message-ID: <alpine.DEB.1.10.0804100951190.21749@mtl.rackplans.net>
References: <47FCF9DD.6080007@rtr.ca>  <20080410.023045.16227424.yoshfuji@linux-ipv6.org>  <47FD138B.2060801@rtr.ca> <20080409.152933.132174258.davem@davemloft.net>  <47FD590C.5020003@rtr.ca> <1207787848.16220.25.camel@brick>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2008, Harvey Harrison wrote:

> Date: Wed, 09 Apr 2008 17:37:28 -0700
> From: Harvey Harrison <harvey.harrison@gmail.com>
> To: Mark Lord <lkml@rtr.ca>
> Cc: David Miller <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
>     jeff@garzik.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
>     linux-net@vger.kernel.org
> Subject: Re: 2.6.25-rc8: FTP transfer errors
> 
> On Wed, 2008-04-09 at 20:02 -0400, Mark Lord wrote:
> > David Miller wrote:
> > > From: Mark Lord <lkml@rtr.ca>
> > > Date: Wed, 09 Apr 2008 15:05:47 -0400
> > > 
> > >> But it would be far more useful for whoever has been working on the
> > >> stack to suggest some possible/likely commits to look at instead.
> > > 
> > > Personally all I see is that one side closes the socket before all
> > > data packets received have been read into the application, resulting
> > > in a (correct) reset going out.
> > > 
> > > I can't think of any change we've made over the course of this
> > > release that would change behvaior in that area.
> > > 
> > > So you will likely need to bisect.
> > ..
> > 
> > Or I can ignore it, like the net developers, since I have a workaround.
> > And then we'll see what other apps are broken upon 2.6.25 final release.
> > 
> > Really, folks.  Bug reports are intended to *help* the developers,
> > not something to be thrown back in their faces.
> > 
> > There do seem to have been a *lot* of changes around the tcp closing/close
> > code (as I see from diff'ing 2.6.24 against latest -git).
> > 
> > *Somebody* is responsible for those changes.
> > That particular *somebody* ought to volunteer some help here,
> > reducing the mountain of commits to a big handful or two.
> > 
> 
> Could you do a poor-man's bisect and test 2.6.25-rc1 and -rc2, that
> would probably help a lot to narrow it down.


Seeing as how your Canadian.. any way to make sure it's not ISP (bell or 
bell wholesale) / rogers traffic shaping ?

	Gerhard

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
