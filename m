Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbXIASKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbXIASKL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 14:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbXIASJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 14:09:59 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:46105 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbXIASJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 14:09:58 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 1 Sep 2007 13:58:17 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Dave Jones <davej@redhat.com>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
In-Reply-To: <20070901172231.GA28391@redhat.com>
Message-ID: <Pine.LNX.4.64.0709011352390.20094@localhost.localdomain>
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain>
 <46D89800.8080701@s5r6.in-berlin.de> <Pine.LNX.4.64.0709010435070.26137@localhost.localdomain>
 <46D9306C.9040301@s5r6.in-berlin.de> <Pine.LNX.4.64.0709010533260.29190@localhost.localdomain>
 <20070901172231.GA28391@redhat.com>
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

On Sat, 1 Sep 2007, Dave Jones wrote:

> On Sat, Sep 01, 2007 at 05:41:06AM -0400, Robert P. J. Day wrote:
>
>  > this whole attribute thing is not adding anything breathtaking new,
>  > it's simply taking the example set by EXPERIMENTAL and generalizing
>  > it and making it more convenient in the process.
>
> The problem I see with this whole maturity levels idea is that
> you've missed that 'EXPERIMENTAL' is largely a complete failure
> because everyone ends up enabling it due to needing something
> dependant on it.

i agree.  and the reason for that is that people use that qualifier
liberally and never get rid of it.  not that long ago, i posted to the
janitors list and suggested that, as a project, people peruse the
source tree and find stuff marked EXPERIMENTAL that's clearly been
stable for years, and remove that dependency.  i personally submitted
a patch that removed that qualifier from the ATM stuff.

the *idea* of EXPERIMENTAL is not the problem -- the problem is that
people apply it and ***never take it off again***.

> People just don't care about how mature an option is if they need a
> driver/feature.  *No-one* is going to come across options and think
> "Oh, the driver for my network card isn't stable. Guess I'll not
> enable it". And the idea of hiding the options behind multiple
> levels of maturity options sounds completely batshit.

ok.  so, at this point, i think it's safe to drop the whole idea,
since more than enough people don't like it or, conversely, they like
it but seem adamant about butchering it badly to the point of
uselessness.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
