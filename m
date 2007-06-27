Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbXF0BjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbXF0BjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 21:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbXF0BjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 21:39:12 -0400
Received: from ns2.suse.de ([195.135.220.15]:33187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbXF0BjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 21:39:11 -0400
Date: Wed, 27 Jun 2007 03:39:03 +0200
From: Nick Piggin <npiggin@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] remove nobh_{prepare,commit}_write()
Message-ID: <20070627013903.GA21268@wotan.suse.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070614221555.GY3588@stusta.de> <20070626133203.d1aa5383.akpm@linux-foundation.org> <1182890938.11569.27.camel@kleikamp.austin.ibm.com> <20070626142320.9336df5b.akpm@linux-foundation.org> <20070626143335.684887f9.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626143335.684887f9.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 02:33:35PM -0700, Randy Dunlap wrote:
> On Tue, 26 Jun 2007 14:23:20 -0700 Andrew Morton wrote:
> 
> > On Tue, 26 Jun 2007 15:48:58 -0500
> > Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> > 
> > > On Tue, 2007-06-26 at 13:32 -0700, Andrew Morton wrote:
> > > > On Fri, 15 Jun 2007 00:15:55 +0200
> > > > Adrian Bunk <bunk@stusta.de> wrote:
> > > > 
> > > > > nobh_{prepare,commit}_write() are no longer used.
> > > > 
> > > > wth?  What happened to ext2 and ext3 nobh mode?  They seem to
> > > > have magically and unchangeloggedly disappeared?
> > > 
> > > They were removed with Nick's new aops patches.
> >            ^secretly
> > > 
> > 
> > That much I worked out for myself.  It's kinda staggering that a fairly
> > major feature in two fairly major filesystems got removed without even a
> > mention in the changelog.  I don't recall having seen it discussed in email
> > but I obviously missed that bit.
> > 
> > Look, I'm one micron from just dropping the whole lot.  These changes
> > simply have not received the amount of energy, effort, care, attention and
> > testing which a change of this magnitude requires.
> 
> so be sure to discuss that (not the patches themselves so much,
> but the process(es)) at the kernel summit etc....

I did of course mention that nobh wasn't converted when sending the
patches.

I asked for comments about how much it is used in real world. Badari
was the only one who replied about that but we didn't reach a conclusion.

I don't know about energy, but I have seen lots of other patches cause
a lot more problems...
