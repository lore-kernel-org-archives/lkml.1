Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbYIAKNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbYIAKNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 06:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYIAKN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 06:13:26 -0400
Received: from smtp.nokia.com ([192.100.105.134]:22275 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYIAKN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 06:13:26 -0400
Date: Mon, 1 Sep 2008 13:12:52 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Bryan Wu <cooloney@kernel.org>
Cc: felipe.balbi@nokia.com, David Brownell <david-b@pacbell.net>,
       Felipe Balbi <felipebalbi@users.sourceforge.net>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: HAVE_CLK (for <linux/clk.h> support)
Message-ID: <20080901101252.GD7041@gandalf.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <200805231044.59969.david-b@pacbell.net> <200805271614.55233.david-b@pacbell.net> <31e679430805271701h73ee1eb2p80329900008827f8@mail.gmail.com> <200805271841.16793.david-b@pacbell.net> <386072610809010248l78e9c661i130c3fa4b84b0a3c@mail.gmail.com> <20080901100021.GB7041@gandalf.research.nokia.com> <386072610809010305g2e728e1p282f0a2b8e7ba43e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <386072610809010305g2e728e1p282f0a2b8e7ba43e@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 01 Sep 2008 10:12:55.0051 (UTC) FILETIME=[4CE535B0:01C90C1B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 06:05:19PM +0800, ext Bryan Wu wrote:
> On Mon, Sep 1, 2008 at 6:00 PM, Felipe Balbi <felipe.balbi@nokia.com> wrote:
> > On Mon, Sep 01, 2008 at 05:48:14PM +0800, ext Bryan Wu wrote:
> >> Sorry for jumping in so later. I noticed Blackfin does not support
> >> HAVE_CLK currently.
> >> As the HAVE_CLK dependence is included in the kernel mainline, MUSB
> >> parts do not show up in the Kconfig because of lacking of HAVE_CLK.
> >>
> >> To implement clk infrastructure in Blackfin will be later than merging
> >> MUSB Blackfin parts to upstream.
> >>
> >> Any idea?
> >
> > dude, you're really late on this one. Now that musb depends on HAVE_CLK
> > and we have things working for that. What you can do is locally (on your
> > tree) remove the HAVE_CLK dependency so you can keep musb development
> > going. But don't push that patch upstream. Meanwhile, you'll have time
> > to implement clk framework support for blackfin.
> >
> 
> Too bad, I just realize this when I try to port my local blackfin
> patch for upstream merge.
> You're right, currently I remove the dependency locally. So I need to
> add a new task to implement clk framework for Blackfin.
> 
> OK, another question, do you know where is the latest usb development
> git tree, buddy?

I replied on the other mail :-)

It's a quilt tree on kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/

Just take a look at MAINTAINERS file ;-)

-- 
balbi
