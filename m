Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbZAFWgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbZAFWgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757357AbZAFWSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:18:15 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:33780 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846AbZAFWSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:18:14 -0500
Date: Tue, 6 Jan 2009 23:19:52 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>
Subject: Re: [PATCH 03/23] cris: introduce asm/swab.h
Message-ID: <20090106221952.GD23838@uranus.ravnborg.org>
References: <1231277446.964.260.camel@brick> <alpine.LFD.2.00.0901061357150.3057@localhost.localdomain> <1231279452.25147.1.camel@brick> <alpine.LFD.2.00.0901061409270.3057@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901061409270.3057@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 02:11:43PM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 6 Jan 2009, Harvey Harrison wrote:
> > 
> > Sure, I sent regular patches as a courtesy to Andrew in case he slurped
> > it up, but I can resend with -M -B if you're going to take it directly,
> > should I wait until I see the remaining 4 arches hit your tree, or will
> > you worry about the timing?
> 
> I'm not sure worrying about the timing makes much sense, since the bigger 
> worry is wanting to merge things in time for -rc1 - and that means having 
> a few days to catch any gotcha's. If parisc/xtensa/cris is broken for a 
> day or two, I don't consider that a problem. 

mn10300, frv and maybe h8300 are waiting for these patches to hit mainline
before they move their headers to arch/$ARCH/include

So sooner is better so we can get the rest fixed in this respect.

For m68k I have sent a patch to unify the headers for m68k and m68knommu
in arch/m68k/include/...

I really hope it is heading towards you soon.

	Sam
