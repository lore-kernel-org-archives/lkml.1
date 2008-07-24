Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbYGXGwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbYGXGwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 02:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbYGXGwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 02:52:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:40051 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYGXGwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 02:52:38 -0400
Date: Thu, 24 Jul 2008 08:52:34 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jack Steiner <steiner@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: GRU driver feedback
Message-ID: <20080724065234.GB10972@wotan.suse.de>
References: <20080723141229.GB13247@wotan.suse.de> <20080724032627.GA36603@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724032627.GA36603@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 10:26:28PM -0500, Jack Steiner wrote:
> On Wed, Jul 23, 2008 at 04:12:30PM +0200, Nick Piggin wrote:
> > 
> > Hi Jack,
> > 
> > Some review of the GRU driver. Hope it helps. Some trivial.
> 
> Thanks for the feedback. I'm at OLS this week & barely reading email.
> I'll go thru the comments as soon as I get home next week & will
> respond in detail then.

OK, no problem. Andrew said he's happy to hold off the driver merge
for a bit and we should be able to drop it in post-rc1 if we can get
it sorted out.


> > - I would put all the driver into a single patch. It's a logical change,
> >   and splitting them out is not really logical. Unless for example you
> >   start with a minimally functional driver and build more things on it,
> >   I don't think there is any point avoiding the one big patch. You have to
> >   look at the whole thing to understand it properly anyway really.
> 
> I would prefer that, too, but was told by one of the more verbose
> kernel developers (who will remain nameless) that I should split the code
> into multiple patches to make it easier to review. Oh well.....

I don't want to make a big stink out of it. But I don't understand
why half (or 1/5th) of a driver is a particularly good unit of change.
1. basic functionality, 2. more stuff, 3. documentation, 4. kconfig or
some such splitup seems more appropriate if it really must be split,
but IMO each change should as much as possible result in a coherent
complete source tree before and after.

Anyway, yeah, no big deal so if Andrew decided to merge them together
or leave them split, I go along with that ;)

