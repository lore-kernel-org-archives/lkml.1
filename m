Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbYATFPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbYATFPG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 00:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYATFO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 00:14:56 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58149 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbYATFOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 00:14:55 -0500
Date: Sun, 20 Jan 2008 06:18:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Newall <davidn@davidnewall.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080120051822.GB19784@one.firstfloor.org>
References: <20080119045918.GA12215@basil.nowhere.org> <4792B191.2060801@davidnewall.com> <20080120031153.GB6275@one.firstfloor.org> <4792D221.1010704@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4792D221.1010704@davidnewall.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2008 at 03:16:25PM +1030, David Newall wrote:
> Andi Kleen wrote:
> > On Sun, Jan 20, 2008 at 12:57:29PM +1030, David Newall wrote:
> >   
> >> compatibility.  This is a sleeping giant for Linux.  There are plenty of
> >>     
> >
> > Interesting choice of words.
> >   
> KFC and Dominoes use SCO for their cash registers, to pick just two
> enormous future opportunities.

I suppose if they update their cash registers they will just go 
with fully Linux binaries.

> > But it does not make sense for all Linux kernels to always check for iBCS executables
> > when they don't have to code to run them anyways.
> >   
> 
> I don't suppose you're suggesting this will make a big difference.  Even
> if every exec did nothing but immediately exit, it still wouldn't make
> much difference.

It's not a big difference, but why do unnecessary work on all 
Linux kernels? There are a lot of Linux machines out there and 
if all of them only do a little unnecessary work each fork()
over a year it adds up to really a lot of wasted cycles.

Especially since the few people who might really
need it can easily readd it.

> Likewise, I take your point about proper iBCS support (and I suppose
> it's really iBCS2 that we're talking about.)  My concern is that
> removing this now gains almost nothing, 2 strcmp per exec is as close to
> nothing as anything, but it sends a message with which I disagree.  The
> message should be that Linux is good for, well the same things FreeBSD
> is, and includes running Solaris and SCO binaries.  This is a major

But Linux is not good for this currently, at least not unless you
add a significant patch (which I'm not sure does even exist
for modern 2.6; iBCS was mainly deployed on 2.4 kernels). And when you 
add that patch you can easily readd the strcmps too.

> simplification of the story, I know, but still hits the plot highlights.

You're worried about this patch generating headlines?

-Andi
