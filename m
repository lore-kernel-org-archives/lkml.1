Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbYCBSFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbYCBSFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 13:05:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbYCBSE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 13:04:58 -0500
Received: from the.earth.li ([217.147.81.2]:35017 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbYCBSE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 13:04:57 -0500
Date: Sun, 2 Mar 2008 18:04:56 +0000
From: Simon Huggins <huggie@earth.li>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Scheduler broken? sdhci issues with scheduling
Message-ID: <20080302180456.GS24533@paranoidfreak.co.uk>
References: <20080229115256.GG24533@paranoidfreak.co.uk> <20080302104031.GB3861@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080302104031.GB3861@ucw.cz>
X-Attribution: huggie
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiya Pavel,

(please cc me)

On Sun, Mar 02, 2008 at 11:40:31AM +0100, Pavel Machek wrote:
> On Fri 2008-02-29 11:52:57, Simon Huggins wrote:
> > [ Please Cc me on replies ]
> > I had a bug with sdhci which Pierre Ossman looked at for me.
> > In the end essentially the fix was to use HZ=1000 and nothing else.
> > Pierre seemed to think that this was a bug in the scheduler.
> > I'm interested if someone who groks the scheduler could take a look at
> > the mmc/* code and see if it's abusing HZ or if there's anything
> > obviously wrong there.  If it's not then perhaps there really is a bug
> > in the scheduler?
> Is mmc slow or does it just break down? Slow would be expected, but
> breaking down should be fixed in MMC, too...

It just doesn't work.  It won't detect that a card has been inserted and
doesn't create the device nodes for it though it does log lots of data
where it tries.

Pierre explained further up this thread on why it tries to do what it
does but for some reason he's not seeing the expected behaviour from the
scheduler.

As a user I don't care where the bug is fixed :)

-- 
Simon Huggins  \ "Ah.  So you're a waffle man!" - Talkie Toaster
                \
http://www.earth.li/~huggie/                                htag.pl 0.0.22
