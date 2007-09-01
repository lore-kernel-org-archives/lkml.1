Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbXIAKFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbXIAKFs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 06:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXIAKFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 06:05:38 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:34510 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbXIAKFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 06:05:37 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 1 Sep 2007 05:54:14 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
In-Reply-To: <46D93544.2030308@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0709010548200.29584@localhost.localdomain>
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain>
 <46D89800.8080701@s5r6.in-berlin.de> <Pine.LNX.4.64.0708312109580.7060@localhost.localdomain>
 <46D92D8E.9020508@s5r6.in-berlin.de> <Pine.LNX.4.64.0709010513460.28329@localhost.localdomain>
 <46D93544.2030308@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Sep 2007, Stefan Richter wrote:

> Robert P. J. Day wrote:
> > given the possible interpretations of EXPERIMENTAL that i hadn't
> > considered until now, maybe it really *does* make sense to tag
> > something as both EXPERIMENTAL and, say, DEPRECATED (does it?).
>
> In theory maybe, for communication purposes perhaps rather not.
>
> The reasoning why a feature is deprecated will typically include the
> gotchas which caused the feature to be considered experimental, if
> such gotchas still apply.

fair enough. there may be times when people won't agree when something
is actually "deprecated."  but in cases of actual disagreement, the
easiest solution is to do nothing -- leave that feature untagged, it
won't hurt anything.  it would be like arguing about whether something
should currently depend on EXPERIMENTAL.  who cares?  a user can
simply click on whether they want to see EXPERIMENTAL stuff, anyway.

the places where this makes sense is where everyone agrees that
something is now officially deprecated -- like when it gets its own
entry in the features removal file with a scheduled removal date.
once that happens, it's beyond the point of debate.

but so what if something gets mis-classified every so often?  you
always have the ability to ignore all that attribute classification in
the end, anyway.  no harm, no foul.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
