Return-Path: <linux-kernel-owner+w=401wt.eu-S1946521AbXD3RJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946521AbXD3RJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946519AbXD3RJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:09:53 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946515AbXD3RJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:09:49 -0400
Date: Mon, 30 Apr 2007 10:09:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: condingstyle, was Re: utrace comments
Message-Id: <20070430100917.439ebfc8.akpm@linux-foundation.org>
In-Reply-To: <20070430091121.GC31397@infradead.org>
References: <20061127165138.GA2991@lst.de>
	<20070430040213.BF9901801A4@magilla.sf.frob.com>
	<20070430091121.GC31397@infradead.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 10:11:21 +0100 Christoph Hellwig <hch@infradead.org> wrote:

> I've separated this out under a new subject because some style issues
> that so far aren't documented explicitly are in doubt here, and Roland
> wants and Answer from Andrew.
> 
> We also should put clauses on this into CodingStyle.
> 
> 
> On Sun, Apr 29, 2007 at 09:02:13PM -0700, Roland McGrath wrote:
> > > 	The coding style here is wrong.  The else should be on the line
> > > 	of the closing brace.  
> > 
> > I can ordinarily ignore syntax, but this is an abomination in the sight
> > of the Lord and always will be.  Fortunately, it's far from being 100%
> > consistently used in the kernel already.  People are welcome to change
> > the code after I submit it, but I just can't make myself write it that
> > way, sorry.

I'm a bit lost here.  Are we referring to

	if (expr) {
		...
	} else {
		...
	}

versus

	if (expr) {
		...
	}
	else {
		...
	}

?

If so the former is usual style.  People do add code which does the latter,
but it tends to get fixed up later on when someone else does some work on
the same code.

> > > 	This doesn't follow kernel coding style at all, we always
> > > 	put the && or || operators at the end of the closing line.
> > 
> > I could swear I've been "corrected" in the opposite direction on this one.
> > It is not mentioned in Documentation/CodingStyle, and the existing kernel
> > code is far from consistent on it.  I really don't care which way it is,
> > but I'd like clear authoritative direction from Linus and Andrew before I
> > bother with it.

This is

	if (expr1 &&
		expr2)

versus

	if (expr1
		&& expr2)

the former is more common and is, IMO, more readable.

The latter can be handy sometimes to prevent an 80-col overflow in the
first line.

