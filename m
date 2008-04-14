Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbYDNFtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbYDNFtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 01:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYDNFt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 01:49:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752340AbYDNFtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 01:49:25 -0400
Date: Sun, 13 Apr 2008 22:48:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <dwmw2@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-Id: <20080413224800.57d227e4.akpm@linux-foundation.org>
In-Reply-To: <20080414013248.GB30489@hash.localnet>
References: <20080413033344.GA27494@hash.localnet>
	<20080412205544.5e12a7d4.akpm@linux-foundation.org>
	<20080413080130.GA9622@infradead.org>
	<20080413012001.8d7967f4.akpm@linux-foundation.org>
	<20080413082815.GA20108@infradead.org>
	<E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
	<1208121358.2700.4.camel@shinybook.infradead.org>
	<20080413154459.4b2f125d.akpm@linux-foundation.org>
	<20080413234920.63711ca7@core>
	<20080413161014.cb06964c.akpm@linux-foundation.org>
	<20080414013248.GB30489@hash.localnet>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 21:32:48 -0400 Bob Copeland <me@bobcopeland.com> wrote:

> On Sun, Apr 13, 2008 at 04:10:14PM -0700, Andrew Morton wrote:
> > On Sun, 13 Apr 2008 23:49:20 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > > 	This filesystem has only 20 users.
> > 
> > None of that means that merging this filesystem is the best decision.
> 
> Well, 20 may have been aiming just a tad low.  I'd never make it in sales.
> Here are the stats from linux-karma.sf.net:
> 
>  - most recent release, for 2.6.25: 36 downloads since 3/16/08
>  - # subscribers on mailing list: 39 [1]
>  - most # of downloads of a given release: 252 (May-Oct 2007) [2]
> 
> [1] Some subscribers may not use the FS at all since there is also
> software for using the ethernet interface.  Both are discussed on 
> the list.
> 
> [2] I doubt that 252 d/ls translates to that many _current_ users; a
> year is a long time in consumer electronics.  I don't have stats on 
> unique IPs.
> 
> I'm unaware of ReplayTV users - one guy contacted me once and then
> disappeared.

OK.

> > Merging a new filesystem has costs - I don't need to enumerate them.  Do
> > the benefits of OMFS exceed them?
> 
> You guys would know best.  I can see both arguments...

Well as I say - no strong opinions either way here.  It just seems a bit
odd to burden the kernel with an additional fs for such a small user base
when either options exist.

OTOH when we merge a new fs that also has the side-effect of increasing the
active developer base - the maintainers of the fs fix other stuff.  And
I'll do anything to get some acpi bugs fixed ;)

So.. whatever.  I'll keep a look out for v4.
