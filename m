Return-Path: <linux-kernel-owner+w=401wt.eu-S1750701AbXBMOrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750701AbXBMOrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750707AbXBMOrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:47:12 -0500
Received: from thunk.org ([69.25.196.29]:50091 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbXBMOrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:47:10 -0500
Date: Tue, 13 Feb 2007 09:47:02 -0500
From: Theodore Tso <tytso@mit.edu>
To: "Martin A. Fink" <fink@mpe.mpg.de>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
Message-ID: <20070213144702.GD8670@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Martin A. Fink" <fink@mpe.mpg.de>, Alan <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org
References: <200702121502.17130.fink@mpe.mpg.de> <200702131034.22639.fink@mpe.mpg.de> <20070213112527.59eaa504@localhost.localdomain> <200702131332.34899.fink@mpe.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702131332.34899.fink@mpe.mpg.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 01:32:34PM +0100, Martin A. Fink wrote:
> > Does the FreeBSD fsync sync to media ? Also what controller is being used
> > here, and do you have EHCI USB support running ?
>
> Manual of FreeBSD fsync says it syncs to media.

That didn't answer the question.  With SATA in particular, just
because you flush it to the *disk*, doesn't mean that you've flushed
it to the *media*, unless the OS is explicitly giving an command to
the disk to do so.  If you haven't done any tests where you sync a
huge amount of data on FreeBSD, and then immediate manually kick the
power plug out of the wall, and then checking to make sure all of the
data actually did make it to the media, I wouldn't necessary assume
that it has.  Given that it sounds like you really care about this,
I'd suggest that you explicitly testing this before making
assumptions.

							- Ted
