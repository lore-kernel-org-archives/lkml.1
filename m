Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbXEINBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbXEINBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbXEINBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:01:40 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:53286 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbXEINBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:01:38 -0400
X-Originating-Ip: 99.246.112.70
Date: Wed, 9 May 2007 09:00:03 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Pavel Machek <pavel@ucw.cz>
cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-pcmcia@lists.infradead.org
Subject: Re: pcmcia ioctl removal
In-Reply-To: <20070509125415.GA4720@ucw.cz>
Message-ID: <Pine.LNX.4.64.0705090858240.4919@localhost.localdomain>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <20070501084623.GB14364@infradead.org> <20070509125415.GA4720@ucw.cz>
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

On Wed, 9 May 2007, Pavel Machek wrote:

> Hi!
>
> > >  pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
> >
> > ...
> >
> > > Dominik is busy.  Will probably re-review and send these direct to Linus.
> >
> > The patch above is the removal of cardmgr support.  While I'd love
> > to see this cruft gone it definitively needs maintainer judgement
> > on whether they time has come that no one relies on cardmgr
> > anymore.
>
> I remember needing cardmgr few months ago on sa-1100 arm system. I'm
> not sure this is obsolete-enough to kill.

in that case, someone really should update
feature-removal-schedule.txt, which currently reads:

What:   PCMCIA control ioctl (needed for pcmcia-cs [cardmgr, cardctl])
When:   November 2005
...

rday
-- 
========================================================================
Robert P. J. Day Linux Consulting, Training and Annoying Kernel
Pedantry Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
