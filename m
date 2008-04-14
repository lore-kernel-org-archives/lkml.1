Return-Path: <linux-kernel-owner+w=401wt.eu-S1762771AbYDNO1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762771AbYDNO1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761994AbYDNOWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:22:47 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23918 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760121AbYDNOWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:22:45 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Date: Mon, 14 Apr 2008 10:20:36 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, me@bobcopeland.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080414091639.4bd3879d@core> <20080414084141.GA29113@infradead.org>
In-Reply-To: <20080414084141.GA29113@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804141020.37271.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008, Christoph Hellwig wrote:
> On Mon, Apr 14, 2008 at 09:16:39AM +0100, Alan Cox wrote:
> > I think the exceed them quite easily. The costs are almost nil, while
> > merging this provides another nice example fs (and one much easier to
> > follow than ext*) for hardware that does have a few users and will no
> > doubt get many more
> >
> > I wasn't aware Linus had introduced a new rule required 500 people sign
> > up to use a feature before it gets added ?
>
> I'm also very surprised by this, especially as it seems to be applied
> very selectively.  This filesystems is an almost 0 maintainance burden
> unlike a lot of really crappy driver we're shoving in constantly.

Thanks to Bob Copeland for taking the time to submit this for mainline.  
Please don't mistake the resulting debate as a sign we don't appreciate the 
effort of making it available and getting it reviewed.

This zero maintenance burden idea is a little suprising to me.  The kernel 
interfaces do change and we either end up changing every filesystem to 
support the new interface or we need to carry around the old ones for the old 
filesystems.

Even though OMFS seems to be using the generic interfaces well, there is still 
a testing burden for every change.  Someone needs to try it, report any 
problems and get them fixed.  Since none of the people making the changes is 
likely to have an OMFS test bed, all of that burden will fall on Bob, his 
users, and anyone who tries to compile the module (Andrew).

Unlike all the device drivers we don't want floating around out of the tree, 
filesystem authors do have a choice between FUSE and being in-kernel.  Since 
OMFS has been maintained out of tree since 2.6.12 or so, Bob probably has a 
very good idea of how much time he has needed to spend updating things for 
each release.

So, there are two big questions I'd ask:

* Which setup (kernel or fuse) would Bob find easier to maintain things?
* Is this a first step toward more development and an increased user base?

Tossing it in -mm isn't a bad step toward getting attention to see if more 
people want to use it.

-chris
