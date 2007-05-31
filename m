Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbXEaWWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbXEaWWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 18:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXEaWWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 18:22:47 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971AbXEaWWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 18:22:46 -0400
Date: Thu, 31 May 2007 15:22:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2/4] 2.6.22-rc3: known regressions
In-Reply-To: <20070531220833.GA10867@beardog.cca.cpqcorp.net>
Message-ID: <alpine.LFD.0.98.0705311516350.26602@woody.linux-foundation.org>
References: <465C188F.9000900@googlemail.com> <465C22F4.8080505@googlemail.com>
 <alpine.LFD.0.98.0705301918450.26602@woody.linux-foundation.org>
 <20070531220833.GA10867@beardog.cca.cpqcorp.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 May 2007, Mike Miller (OS Dev) wrote:

> On Wed, May 30, 2007 at 07:22:14PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Tue, 29 May 2007, Michal Piotrowski wrote:
> > > 
> > > Subject    : Oops on 2.6.22-rc2 when unloading the cciss driver
> > > References : http://lkml.org/lkml/2007/5/24/172
> > > Submitter  : Mike Miller (OS Dev) <mikem@beardog.cca.cpqcorp.net>
> > > Status     : Unknown
> > 
> > I thought this one should be fixed by commit e9ca75b53. Not so?
> 
> I apologize for the slow response. I also apologize that I don't know enough
> about git to figure out what commit e9ca75b53 does.

Even without git, you can use the kernel.org gitweb install:

	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e9ca75b53

(where the "h=...." is the magic part - pick any commit SHA1 you want, 
including short-hand ones like the one I gave).

With git, you just do

	git show e9ca75b53

to see a particular named commit.

> I submitted a fix that was blessed by Eric B. that fixed that Oops.

Ok, I don't think I have anything like that. The one I pointed to is the 
one by Gerald Britton, acked by you ..

But I now realize that that commit was already in -rc2. In fact, it's just 
before the -rc2 release. So while it claims to fix one oops on shutdown, 
it may be the _cause_ of the oops on mudule unload.

		Linus
