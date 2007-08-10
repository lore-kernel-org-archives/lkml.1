Return-Path: <linux-kernel-owner+w=401wt.eu-S965826AbXHJUZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965826AbXHJUZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935518AbXHJUZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:25:20 -0400
Received: from 1wt.eu ([62.212.114.60]:1288 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760554AbXHJUZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:25:19 -0400
Date: Fri, 10 Aug 2007 22:17:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
Message-ID: <20070810201704.GI6002@1wt.eu>
References: <20070809113122.3aa508e4@oldman.hamilton.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809113122.3aa508e4@oldman.hamilton.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Aug 09, 2007 at 11:31:22AM +0100, Stephen Hemminger wrote:
> Since the network device documentation needs a rewrite, I was thinking
> of using basic html format instead of just plain text. But since this would
> be starting an new precedent for kernel documentation, some it seemed
> like a worthwhile topic for discussion.

I've read pro-plain text arguments, so I'll not repeat them. I also see
another advantage to plain text : it's very easy to draw ascii-art
diagrams of anything. It only takes a few minutes, is always inline
and readable with any tool. Look at the bonding doc I wrote and updated
in 2000, people have updated or duplicated some of the diagrams when
they have added features. Something they would definitely not have done
if it had required some strange tool.

Also, the advantage of plain text is that it stays compatible with
everything though the years. Had I used some random tool in 2000 for
this, I'm not sure the tool would still exist right now. Look at RFCs.
Nothing fancy, just readable. Even the TCP FSM in rfc793 from 26 years
ago is readable, understandable, and updatable by anybody (though it's
a little mit messy). And it's somewhat an extreme case ;-)

I'd prefer that you define some writing conventions for plain-text
documents that anyone should try follow, starting with the 80-cols
limit to make Davem happy. I think that many of us can help define
such a "standard" indicating how to underline subtitles, how to
enumerate a list, how to avoid using tabs, how to write boxes and
arrows in their diagrams, etc...

Best regards,
Willy

