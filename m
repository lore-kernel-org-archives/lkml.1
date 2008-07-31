Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbYGaWT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbYGaWT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbYGaWTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:19:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57564 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645AbYGaWTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:19:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux v2.6.27-rc1: linux-next
Date: Fri, 1 Aug 2008 00:22:36 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <alpine.LFD.1.10.0807290945030.3334@nehalem.linux-foundation.org> <20080730020308.a552c4d8.akpm@linux-foundation.org>
In-Reply-To: <20080730020308.a552c4d8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808010022.37049.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 30 of July 2008, Andrew Morton wrote:
> On Tue, 29 Jul 2008 09:59:18 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> >  - I don't think the 'next' thing works as well for the occasional 
> >    developer that just has a few patches pending as it works for subsystem 
> >    maintainers that are used to it.
> 
> Those people's patches are in -mm, which now holds maybe 100 or more
> "trees", many of which are small or empty.
> 
> My project within the next couple of weeks is to get most of that
> material into linux-next.  Stephen will be involved ;)
> 
> >    IOW, I think 'next' needs enough infrastructure setup from the 
> >    developer side that I don't think it's reasonable for _everything_ to 
> >    go through next.
> 
> True.  But
> 
> a) some of the problematic changes which we've seen simply _should_
>    have been in linux-next.  Some of them were even coming from
>    developers whose trees are already in linux-next.
> 
> b) A lot of the bugs which hit your tree would have been quickly
>    found in linux-next too.
> 
> 
> But it's all shuffling deckchairs, really.  Are we actually merging
> better code as a reasult of all of this?  Are we being more careful and
> reviewing better and testing better?
> 
> Don't think so.

Well, if the number of the regressions list entries can be regarded as a
pointer, then yes, we are. :-)

There are 28 entries in there right now, compared to 53 entries initially in
the list during the 2.6.26 cycle (see
http://bugzilla.kernel.org/show_bug.cgi?id=11167 for reference).

Thanks,
Rafael
