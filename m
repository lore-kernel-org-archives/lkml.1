Return-Path: <linux-kernel-owner+w=401wt.eu-S1761562AbYF3REW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562AbYF3REW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYF3REO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:04:14 -0400
Received: from trinity.fluff.org ([89.145.97.151]:55381 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYF3REN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:04:13 -0400
Date: Mon, 30 Jun 2008 18:04:08 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Harald Welte <laforge@openmoko.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       linux-kernel@vger.kernel.org, tk@maintech.de
Subject: Re: [patch v4 02/17] MMC: S3C24XX: Fix the checkpatch.pl errors in the s3cmci driver
Message-ID: <20080630170408.GE8489@trinity.fluff.org>
References: <20080630152547.755285683@fluff.org.uk> <20080630152747.132370982@fluff.org.uk> <20080630175018.356568b7@mjolnir.drzeus.cx> <20080630161537.GD8489@trinity.fluff.org> <20080630163601.GD5043@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630163601.GD5043@prithivi.gnumonks.org>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 12:36:01AM +0800, Harald Welte wrote:
> On Mon, Jun 30, 2008 at 05:15:37PM +0100, Ben Dooks wrote:
> > On Mon, Jun 30, 2008 at 05:50:18PM +0200, Pierre Ossman wrote:
> > > On Mon, 30 Jun 2008 16:25:49 +0100
> > > Ben Dooks <ben-linux@fluff.org> wrote:
> > > 
> > > > Fix the checkpatch and other problems pointed out by
> > > > akpm.
> > > > 
> > > > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> > > > 
> > > 
> > > I prefer to have this one merged into 01 as you'll end up with a commit
> > > that you cannot compile otherwise. Besides, running checkpatch is
> > > something you do before submitting anyway, not as a separate cleanup. :)
> > 
> > In this case I kept it seperate as the cleanups where done by myself
> > as the original driver authour is not interested or too busy to do
> > these himself. Basically, I was trying to keep the driver and my own
> > cleanup work seperate.
> 
> don't worry about that.  Thomas Kleffel is unlikely to return to do any
> active work on it (I know him personally), and the OpenMoko community
> will inevitably rebase its patches based on whatever ends up in
> mainline.  So nobody is worried if you merge all that stuff into one
> patch.  It's probably polite to add the significant contributors (such
> as yourself and myself) to the list of authors at the beginning of the
> file though - given the amount of changes the driver has received
> compared to Tomas' original.

Thanks, having an public discussion about the position of the original
authour is useful. I was intending on submitting a patch once this lot
is merged to add myself and select others to the driver after the fact
so that everyone can acknowledge it.

You have missed part of the point. My extra work is not a small
set of changes which won't get counted when profiling the Kernel
contributors. My employers have given me time to sort these
items out, and we do get work off the fact that we're shown to be in
the leading contributors (iirc, 18th last-year) so I was trying to
ensure that this wasn't lost.

If Pierre or Thomas has objections to either then the series can
be reposted with #1 and #2 merged together.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.
