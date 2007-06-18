Return-Path: <linux-kernel-owner+w=401wt.eu-S932506AbXFRWax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbXFRWax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764646AbXFRWaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:30:46 -0400
Received: from iabervon.org ([66.92.72.58]:2689 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764498AbXFRWap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:30:45 -0400
Date: Mon, 18 Jun 2007 18:30:42 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Carlo Wood <carlo@alinoe.com>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, eric@anholt.net, zhenyu.z.wang@intel.com,
       lethal@linux-sh.org, y-goto@jp.fujitsu.com
Subject: Re: 2.6.22-rc5 regression
In-Reply-To: <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706181828360.4740@iabervon.org>
References: <20070617182254.GA17595@alinoe.com> <20070617195805.GA6125@alinoe.com>
 <20070617214905.GA6207@alinoe.com> <alpine.LFD.0.98.0706180950130.14121@woody.linux-foundation.org>
 <20070618181225.GB8054@alinoe.com> <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org>
 <20070618195415.GA7481@alinoe.com> <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Linus Torvalds wrote:

> On Mon, 18 Jun 2007, Carlo Wood wrote:
>
> > diff --git a/scripts/package/Makefile b/scripts/package/Makefile
> > index 7c434e0..f758b75 100644
> > --- a/scripts/package/Makefile
> > +++ b/scripts/package/Makefile
> 
> but this one has actually been modified. To this:
> 
> > +# Dummy file 
> > +help:
> 
> And finally, 
> 
> > diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> > deleted file mode 100644
> > index 6edb29f..0000000
> 
> That one also has been actually deleted. And "make distclean" doesn't do 
> that. You have something else going on.

Probably make-kpkg removing the in-tree instructions for building debian 
packages so that its own rules will be used instead or something like 
that.

	-Daniel
*This .sig left intentionally blank*
