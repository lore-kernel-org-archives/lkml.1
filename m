Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbXIAJdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbXIAJdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 05:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbXIAJdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 05:33:14 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:33822 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbXIAJdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 05:33:13 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 1 Sep 2007 05:21:34 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
In-Reply-To: <46D92D8E.9020508@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0709010513460.28329@localhost.localdomain>
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain>
 <46D89800.8080701@s5r6.in-berlin.de> <Pine.LNX.4.64.0708312109580.7060@localhost.localdomain>
 <46D92D8E.9020508@s5r6.in-berlin.de>
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
> > *attributes* would be orthogonal to one another -- the values
> > *within* an attribute would be mutually exclusive.
>
> Ah, right.

great, we got that cleared up.  onward.

> In the context of kernel features, "experimental" doesn't mean that
> developers are conducting experiments, but rather that users may use
> it for experimental purposes.  Kernel packagers/ distributors/
> admins/ users are advised that this feature is not for use in
> production (for whatever reasons, e.g. proof-testing not completed,
> known instability, lack of compatibility, missing features).
>
> I have no advise into which attribute to put this and which
> alternative values that attribute could assume.

at this point, i'm not sure either.  given the possible
interpretations of EXPERIMENTAL that i hadn't considered until now,
maybe it really *does* make sense to tag something as both
EXPERIMENTAL and, say, DEPRECATED (does it?).  that suggests you might
want to have two orthogonal attributes:

  maturity:  untagged/normal, DEPRECATED, OBSOLETE
  quality(?):  untagged/normal, EXPERIMENTAL, BROKEN

obviously, maturity would represent the position in the normal life
span of a feature as it progresses from useful to obsolete, while
quality would identify its perceived quality of code.  and those would
(clearly?) be two independent attributes you could apply to any
feature, and be able to select independently.

anyway, this is sort of covered in my earlier post from this morning.
i think.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
