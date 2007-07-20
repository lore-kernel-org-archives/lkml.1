Return-Path: <linux-kernel-owner+w=401wt.eu-S933453AbXGTSAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453AbXGTSAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 14:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761738AbXGTSAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 14:00:22 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40507 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbXGTSAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 14:00:20 -0400
Date: Fri, 20 Jul 2007 12:00:19 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Denis Cheng <crquan@gmail.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] run scripts/Lindent on it to match Documentation/CodingStyle
Message-ID: <20070720180019.GJ14791@parisc-linux.org>
References: <1184489571313-git-send-email-crquan@gmail.com> <4699EEA9.6070709@simon.arlott.org.uk> <20070720170743.GF14791@parisc-linux.org> <46A0F282.8070103@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A0F282.8070103@simon.arlott.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 06:36:02PM +0100, Simon Arlott wrote:
> On 20/07/07 18:07, Matthew Wilcox wrote:
> > sed -i -e 's/^\t*      \(\w*:\)/ \1/' "$@"
> > 
> > which will replace the leading tabs and spaces with one space.
> 
> ... isn't the space thing a workaround for a "diff -p" bug?

Yes.  I like not being affected by bugs.  If you prefer to be affected
by bugs, that's up to you.

> Labels should either not have any indent or be indented by tabs (since
> some code could presumably benefit from indenting labels).

Indenting labels implies that they might be scoped with the other code
at that level of indentation.  If you see code that looks like this:

	for () {
		switch () {
		case foo:
			while () {
				if () {
				} else {
 quux:
 				}
			}
		}
	}

you really want the quux standing out at you.  Otherwise you might think
this was a nice, easy to understand function.

> Mass
> replacing any labels run through Lindent with space prefixes would seem
> like a bad idea :/

We don't tend to mass-run code through Lindent.  This may or may not be
a bad thing, but the fact is that it just doesn't happen.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
