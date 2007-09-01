Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbXIAIqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbXIAIqG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 04:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbXIAIpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 04:45:55 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:32812 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbXIAIpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 04:45:54 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 1 Sep 2007 04:34:24 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
In-Reply-To: <20070831230215.GF11499@redhat.com>
Message-ID: <Pine.LNX.4.64.0709010425400.26137@localhost.localdomain>
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain>
 <20070831230215.GF11499@redhat.com>
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

On Fri, 31 Aug 2007, Dave Jones wrote:

> On Fri, Aug 31, 2007 at 05:38:34PM -0400, Robert P. J. Day wrote:

> > it's a natural progression and, at any point, a feature cannot
> > possibly have more than one maturity value.  it would be as absurd
> > as saying that someone was a teenager *and* was a twenty-something
> > at the same time.  not possible.
>
> Again, not so black and white. It's feasible that something can be
> experimental on one architecture, stable on another (typically x86),
> or even deprecated on x86, but still supported on other
> architectures. It's not just a per arch thing either, in some cases,
> we've had differing levels of maturity based upon other hardware
> constraints, or even varying versions of system software.

absolutely agreed.  but in cases like that, it might just be easier to
not tag that feature *at all*.  nothing in this proposal *forces*
someone to start tagging kernel features in any way.  as you point
out, there may be cases where trying to tag a feature becomes so
hopelessly vague and special-cased, it's easier to just leave it
alone.  but that still doesn't take away from the value of being able
to use this construct elsewhere where its use *is* clear-cut and
unambiguous.

it's like the current use of "EXPERIMENTAL" -- choosing to see
features that are EXPERIMENTAL doesn't change the build process in any
way -- it just affects the choices you're allowed to make.  it doesn't
*force* you to *take* any of those choices.  that's all this new
construct is supposed to do as well.

rday

p.s.  if i read simon's earlier patch correctly, all it's doing right
now is allowing assignment of attributes and values to kernel features
-- it does nothing in terms of being able to use that feature in the
config process.  that would be step two, after this first step is
added and seems to be correct.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
