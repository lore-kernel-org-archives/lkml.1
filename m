Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbXIAJxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbXIAJxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 05:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbXIAJxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 05:53:03 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:34260 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbXIAJxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 05:53:01 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 1 Sep 2007 05:41:06 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
In-Reply-To: <46D9306C.9040301@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0709010533260.29190@localhost.localdomain>
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain>
 <46D89800.8080701@s5r6.in-berlin.de> <Pine.LNX.4.64.0709010435070.26137@localhost.localdomain>
 <46D9306C.9040301@s5r6.in-berlin.de>
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
> > you take advantage of that?  you'd have to add a new
> > structure to "make config" along the following lines:
> >
> >   Along with maturity-untagged features, what other maturity levels
> >   would you like to see and be able to select?
>
> Most (all?) users and presumably most distributors/packagers don't
> decide this globally.  They look at a feature and decide, based on
> their need for this feature, whether they enable or disable it,
> whether they look into alternative hardware/drivers/apps, whether
> they get in touch with the maintainer.

agreed.  but i'm not proposing that *every* feature in the kernel be
investigated to see what category it falls into -- that's clearly an
unreasonable thing to do.

all this new construct is doing is implementing a new way to globally
select or de-select large sets of kernel features to display for user
selection, in exactly the way that EXPERIMENTAL does it now, that's
all.  these attributes would not *force* selection, they would simply
*filter* what to display, nothing more.

this whole attribute thing is not adding anything breathtaking new,
it's simply taking the example set by EXPERIMENTAL and generalizing
it and making it more convenient in the process.

and, as a start, the first thing to do is apply a patch that defines
an attribute and its possible values, and allows kernel features (via
Kconfig files) to be tagged with that attribute, without being able to
do anything with it yet.  one step at a time.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
