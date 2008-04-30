Return-Path: <linux-kernel-owner+w=401wt.eu-S1763988AbYD3TMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763988AbYD3TMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761687AbYD3TMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:12:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41514 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759922AbYD3TMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:12:34 -0400
Date: Wed, 30 Apr 2008 16:12:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: v4l-dvb merge conflicts (Re: linux-next: upstream
 build failure: v4l/dvb)
Message-ID: <20080430161224.71c154ca@gaivota>
In-Reply-To: <20080430134950.03b858e9.sfr@canb.auug.org.au>
References: <20080430114124.45017177.sfr@canb.auug.org.au>
	<20080429230040.45fc6a96@gaivota>
	<20080430134950.03b858e9.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 13:49:50 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Mauro,
> 
> On Tue, 29 Apr 2008 23:00:40 -0300 Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> >
> > On Wed, 30 Apr 2008 11:41:24 +1000
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > Hi all,
> > > 
> > > Today's linux-next build (Linus' tree, x86_64 allmodconfig) fails like
> > > this:
> > > 
> > > ERROR: "tea5767_autodetection" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "tda829x_probe" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "tea5761_autodetection" [drivers/media/video/tuner.ko] undefined!
> > 
> > I suspect that something wrong happened on your compilation, or at linux-next
> > merge. Those three drivers (tea5767, tea5761 and tea829x) were moved
> > from /drivers/media/video to /drivers/common/tuners, but the above messages are
> > pointing to the old path.
> 
> OK, interesting.  This was a build of just Linus' tree so others may get
> this problem if they don't do a "make clean" or similar (as I don't).

We've found some bugs that may explain what you've got. Anyway, most of they
are fixed. I'm preparing a pull request for Linus later today.

> I have now done the merge of the v4l-dvb tree in linux-next and I have had several conflicts, the worst being in the file drivers/media/Kconfig between commit 7c91f0624a9a2b8b9b122cf94fef34bc7f7347a6 ("V4L/DVB(7767): Move tuners to common/tuners") in Linus' tree and commit 9c76e847539ab7a73e82ff692862f3de9fa19ddb ("V4L/DVB(7767): Move tuners to common/tuners") in the v4l-dvb tree. 

The same patch were on both Linus and my tree. -git sometimes don't like
this ;) 

Anyway, I've already dropped those patches that were already applied from my
tree. You should get a clean merge tomorrow.

Cheers,
Mauro
