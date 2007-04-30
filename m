Return-Path: <linux-kernel-owner+w=401wt.eu-S1946888AbXD3XZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946888AbXD3XZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946890AbXD3XZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:25:27 -0400
Received: from ns2.suse.de ([195.135.220.15]:35313 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946887AbXD3XZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:25:17 -0400
From: Neil Brown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 1 May 2007 09:24:39 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17974.31415.121135.794681@notabene.brown>
Cc: Christoph Hellwig <hch@infradead.org>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [-mm patch] i386: enable 4k stacks by default
In-Reply-To: message from Jens Axboe on Monday April 30
References: <20070428191927.GN3468@stusta.de>
	<1177795118.7828.6.camel@localhost>
	<17973.44824.631204.926723@notabene.brown>
	<20070430085916.GA31397@infradead.org>
	<20070430113044.GJ21015@kernel.dk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday April 30, jens.axboe@oracle.com wrote:
> On Mon, Apr 30 2007, Christoph Hellwig wrote:
> > On Mon, Apr 30, 2007 at 06:55:52PM +1000, Neil Brown wrote:
> > > On Saturday April 28, zlynx@acm.org wrote:
> > > > On Sat, 2007-04-28 at 21:19 +0200, Adrian Bunk wrote:
> > > > > 4k stacks have become a well-tested feature used fore a long time in
> > > > > Fedora and even in RHEL 4.
> > > > 
> > > > So has anyone fixed the bugs involving ext3 and LVM snapshots on top of
> > > > DM mirror?
> > > 
> > > Well -mm has a patch which makes stacked block devices much less of an
> > > issue, but this hasn't made it -linus yet - I think the dm developer
> > > isn't happy that dm works properly with it.
> > 
> > I get a little tired about this objection.  If the particular dm code
> > was racy before and this can in theory make it worse it's their problem,
> > and putting in perfectly fine code will give them an incentive to
> > fix their year old race.
> 
> Agree, Neil would you mind if I merged the patch?

I am perfectly happy with this patch being merged - yes.

NeilBrown
