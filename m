Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbYADTBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbYADTBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 14:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYADTBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 14:01:47 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44126 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753337AbYADTBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 14:01:46 -0500
Date: Fri, 4 Jan 2008 14:01:37 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mathieu Segaud <mathieu.segaud@regala.cx>, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Coding Style]: misc fixes for fs/ext{3,4}/acl.{c,h}
	from checkpatch.pl
Message-ID: <20080104190137.GJ17436@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>,
	Mathieu Segaud <mathieu.segaud@regala.cx>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx> <20080104134458.GE17436@mit.edu> <p73hcht8sfr.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73hcht8sfr.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 05:30:00PM +0100, Andi Kleen wrote:
> 
> Exactly. And looking at the patch the old code was already perfectly
> readable anyways. Benefit about zero.

File this under the "checkpatch.pl" considered harmful category....
The problem is not with the tool, but that at least *some* people seem
to think that making checkpatch.pl be completely silent is somehow
this holy grail that will make kernel code bug-free(tm).  (And of
course, people who want to encode nazi-like coding conventions and to
force all of the kernel to use a single coding convention as if that
somehow would improve the kernel's quality.  Some of that is OK, but
as long as the code is readable, do we really care about whether or
not the code is using exactly the same coding conventions everyplace?
Or, pressuring maintainers not to ignore cleanup patches lest they be
viewed as "bad" maintainers?)

Personally I find it annoying, but I'm willing to live with the
cleanup patches.  I don't think they add anything, though.  Maybe I
should be more cranky about such patches....

> The recent flurry of cleanup code patches on l-k causes far more
> problems than it solves. I'm not even sure why people do this? Just
> because it is en vogue recently? 

I don't know, because people want to be able to say that they've
contributed fixes to the Linux kernel?

I will say that in past kernel summit program commitees, the
perception that someone _only_ submitted trivial patches (i.e.,
whitespace-only, spelling fixes in comments, etc.) has sometimes been
perceived a negative factor towards whether the program committee
might consider that person to be useful contributor to discussions at
the kernel summit....  So people should be warned (I would have hoped
that it would be obvious), that submitting vast number of trivial
cleanup patches without contributing anything else will very likely
not work, and possibly backfire if that is your goal.

							- Ted
