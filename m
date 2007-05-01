Return-Path: <linux-kernel-owner+w=401wt.eu-S1031620AbXEAJQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031620AbXEAJQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031613AbXEAJQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:16:50 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60107 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031620AbXEAJQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:16:48 -0400
X-Originating-Ip: 74.109.98.66
Date: Tue, 1 May 2007 05:16:13 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Christoph Hellwig <hch@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-pcmcia@lists.infradead.org
Subject: Re: pcmcia ioctl removal
In-Reply-To: <20070501084623.GB14364@infradead.org>
Message-ID: <Pine.LNX.4.64.0705010514300.9162@localhost.localdomain>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <20070501084623.GB14364@infradead.org>
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

On Tue, 1 May 2007, Christoph Hellwig wrote:

> >  pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
>
> ...
>
> > Dominik is busy.  Will probably re-review and send these direct to Linus.
>
> The patch above is the removal of cardmgr support.  While I'd love
> to see this cruft gone it definitively needs maintainer judgement on
> whether they time has come that no one relies on cardmgr anymore.

since i was the one who submitted the original patch to remove that
stuff, let me make an observation.

when i submitted a patch to remove, for instance, the traffic shaper
since it's clearly obsolete, i was told -- in no uncertain terms --
that that couldn't be done since there had been no warning about its
impending removal.

fair enough, i can accept that.

on the other hand, the features removal file contains the following:

...
What:   PCMCIA control ioctl (needed for pcmcia-cs [cardmgr, cardctl])
When:   November 2005
...

in other words, the PCMCIA ioctl feature *has* been listed as obsolete
for quite some time, and is already a *year and a half* overdue for
removal.

in short, it's annoying to take the position that stuff can't be
deleted without warning, then turn around and be reluctant to remove
stuff for which *more than ample warning* has already been given.
doing that just makes a joke of the features removal file, and makes
you wonder what its purpose is in the first place.

a little consistency would be nice here, don't you think?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
