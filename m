Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbXD1Xbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbXD1Xbj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 19:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbXD1Xbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 19:31:39 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:47390 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbXD1Xbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 19:31:38 -0400
X-Originating-Ip: 74.109.98.66
Date: Sat, 28 Apr 2007 19:31:24 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: random thoughts on DEPRECATED and OBSOLETE
In-Reply-To: <4633CA7F.6010505@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0704281919150.29483@localhost.localdomain>
References: <Pine.LNX.4.64.0704280925270.24691@localhost.localdomain>
 <46337BD2.7000701@s5r6.in-berlin.de> <Pine.LNX.4.64.0704281320560.27098@localhost.localdomain>
 <4633ACE4.50004@s5r6.in-berlin.de> <Pine.LNX.4.64.0704281635190.28274@localhost.localdomain>
 <4633CA7F.6010505@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007, Stefan Richter wrote:

> (Although if a certain number of kernel components is
> inappropriately labeled, the facility becomes useless of course.)

well, sure, but if someone chooses to use a tool incorrectly, there's
really no way to stop them.  and i'm guessing that that sort of thing
would be quickly self-correcting based on peer pressure.  incorrectly
tagged features should become obvious fairly quickly when builds start
to break in unexpected ways.

> You said "it's not just presentational markup", I said "it is". :-)

no, it's not just presentational markup.  it's also a selection or
filtering utility, which i consider distinct from markup.  maybe we're
just disagreeing on semantics, so let's not flog this distinction.

> I see a discussion on OBSOLETE vs. BROKEN there, which even ended in
> a consensus, but I do not see an explicit discussion on OBSOLETE vs.
> DEPRECATED.  The only definition of DEPRECATED I see there is yours,
> and as it is worded, it is largely overlapping with the definition
> of OBSOLETE (which, as it is laid down in that thread, is mostly
> yours too) --- but it is not actually conflicting with it.

in a previous discussion, the definitions were pretty much as follows:

* deprecated:  while a feature is still supported, its use is
discouraged because there is a better alternative that you should
consider migrating to at your convenience.

* obsolete:  while a feature is still in the tree, it is no longer
supported and no one should need it anymore, and everyone *should* be
using the better alternative at this point.

IMHO, there is a clear distinction between those two definitions.
they are not orthogonal, they are mutually exclusive.  put another
way, there is an obvious timeline for features:

  normal -> deprecated -> obsolete

quite simply, based on the above, you can't be deprecated and obsolete
at the same time.

in any event, i don't want to drag this out too much longer.  i think
the proposal is reasonably clear, now it remains to be seen if enough
people think it's worth implementing.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
