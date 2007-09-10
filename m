Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbXIJJYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbXIJJYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 05:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbXIJJYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 05:24:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33588 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748AbXIJJYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 05:24:40 -0400
Date: Mon, 10 Sep 2007 02:23:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, perex@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-Id: <20070910022324.c69e1897.akpm@linux-foundation.org>
In-Reply-To: <20070910090808.GA31204@infradead.org>
References: <20070909202527.GT3563@stusta.de>
	<20070909203920.GA11764@infradead.org>
	<20070909145940.0b41c8a5.akpm@linux-foundation.org>
	<20070910090808.GA31204@infradead.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 10:08:08 +0100 Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Sep 09, 2007 at 02:59:40PM -0700, Andrew Morton wrote:
> > Sure.  But I think it is better to give people some warning when we're
> > planning on breaking out-of-tree things.  I do occasionally receive reports
> > of "hey, the X driver which I get from Y doesn't work any more".  Often
> > it's open-source stuff, too.  I see no point in irritating our users more than
> > we need to.
> 
> There is no fucking reason they should have used it in the first place.

fucking except fucking we fucking exported fucking it fucking so fucking
they fucking used fucking it.  fucking.

Hey, this would be easier with a sed script!  And it so improves the
communication!

> Until we have something like a coherent export API instead of random crap
> exported because someone once needed it to do a dumb thing it'll happen.
> Only way to avoid it is to merge the driver and shake out their dumb ideas
> in the review process.

Well that's why I agreed that we should remove those exports.

> > Adrian knows this, yet he habitually sends zero-warning export-removal
> > patches and I habitually ignore them.  I guess we must both enjoy this or
> > something.
> 
> And I think almost everyone disagrees with you.  We just carry too much
> crap around because of your subborness in this issue, and it gets really
> annoying to have some high up on the food chain fighting his longly flight
> against the other people.

I would like to see "everyone" explain what we lose by giving developers a
bit of warning before we break their stuff.


And it would need to be a good explanation, Christoph.  A measured one
which recognises and then weighs the tradeoffs involved, and the costs.  An
inebriated-sounding rant will not impress, sorry.
