Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbYGWUf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbYGWUf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbYGWUfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:35:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:38405 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbYGWUfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:35:47 -0400
Date: Wed, 23 Jul 2008 13:32:50 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: pHilipp Zabel <philipp.zabel@gmail.com>, Greg KH <gregkh@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Chuck Wolber <chuckw@quantumlinux.com>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       Jake Edge <jake@lwn.net>, Michael Krufky <mkrufky@linuxtv.org>,
       stable@kernel.org, Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [stable] [patch 44/47] pxamci: fix byte aligned DMA transfers
Message-ID: <20080723203250.GA26454@kroah.com>
References: <20080722230208.148102983@mini.kroah.org> <20080722231342.GA8282@suse.de> <20080722231735.GS8282@suse.de> <74d0deb30807230001x176e375cq9a8060c20596f36f@mail.gmail.com> <20080723201258.GA26156@kroah.com> <alpine.LFD.1.10.0807231322250.4754@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807231322250.4754@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 01:24:12PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 23 Jul 2008, Greg KH wrote:
> 
> > On Wed, Jul 23, 2008 at 09:01:34AM +0200, pHilipp Zabel wrote:
> > > 
> > > There is an ugly typo in the patch below that was fixed by Karl Beldan:
> > > http://git.kernel.org/?p=linux/kernel/git/drzeus/mmc.git;a=commit;h=28bbe535df5c461c25eb57affb30e007072429c3
> > > 
> > > Not sure how you handle this, maybe this patch should only go in
> > > together with the other.
> > 
> > As the above mentioned patch isn't in Linus's tree yet, I can't take it.
> > 
> > Care to send it to stable@kernel.org when it does go in?  Or is this
> > current patch just broken without it and not worth adding at all?
> 
> Hmm. I think it's commit 4fe16897c59882420d66f2d503106653d026ed6c 
> upstream. I don't know why it has a different SHA1 in the mmc tree, but I 
> assume that it's because the MMC tree has rebased at some point. Ugh.

Ah, thanks, I missed that.

Hm, that is added post 2.6.26, so I'll add this fixup patch to the
.25-stable tree, and also add this one to the .26-stable queue.

Philipp, is that correct, or does this original one also need to get
added to the .26-stable queue as well?

thanks,

greg k-h
