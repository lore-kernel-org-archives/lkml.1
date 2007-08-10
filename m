Return-Path: <linux-kernel-owner+w=401wt.eu-S940576AbXHJU7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940576AbXHJU7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbXHJU7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:59:23 -0400
Received: from 1wt.eu ([62.212.114.60]:1292 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089AbXHJU7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:59:23 -0400
Date: Fri, 10 Aug 2007 22:51:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
Message-ID: <20070810205117.GJ6002@1wt.eu>
References: <20070809113122.3aa508e4@oldman.hamilton.local> <20070810201704.GI6002@1wt.eu> <20070810204025.GC29549@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810204025.GC29549@fieldses.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 04:40:25PM -0400, J. Bruce Fields wrote:
> On Fri, Aug 10, 2007 at 10:17:04PM +0200, Willy Tarreau wrote:
> > I've read pro-plain text arguments, so I'll not repeat them. I also see
> > another advantage to plain text : it's very easy to draw ascii-art
> > diagrams of anything. It only takes a few minutes, is always inline
> > and readable with any tool.
> 
> Asciidoc should preserve ascii-art diagrams OK; the git docs use them
> all over.
> 
> Not that I'd necessarily push asciidoc.  But:
> 
> > I'd prefer that you define some writing conventions for plain-text
> > documents that anyone should try follow, starting with the 80-cols
> > limit to make Davem happy. I think that many of us can help define
> > such a "standard" indicating how to underline subtitles, how to
> > enumerate a list, how to avoid using tabs, how to write boxes and
> > arrows in their diagrams, etc...
> 
> ... at the point where you actually start setting standards for subtitle
> underlining and list enumeration, you'd want to take another look at
> asciidoc; since it already defines conventions for that stuff (which
> are probably close to what people would do anyway), it might make sense
> just to start using asciidoc.

The problem I have with asciidoc is that it's a nightmare to get it
to work. It's what GIT uses, and after spending a whole day trying
to *build* that thing, I finally resigned and asked Junio if he could
publish the pre-formatted manpages himself, which he agreed to.

All I remember is that there was a very deep level of dependencies
through XML craps^H^H^H^H^Hpackages and I don't remember what magic
things, but one full day trying to build something to read a doc is
too much, so I imagine that I would not even have tried that long
if I had wanted to complete a doc and check that my changes looked
right.

Maybe the language is fine, but the tool needs to build first.

Willy

