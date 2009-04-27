Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbZD0Pr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbZD0Pr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbZD0Prr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:47:47 -0400
Received: from kroah.org ([198.145.64.141]:33617 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbZD0Prq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:47:46 -0400
Date: Mon, 27 Apr 2009 08:40:22 -0700
From: Greg KH <greg@kroah.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git patches] Staging: rtxxx0: cleanup and "dumb" merge
Message-ID: <20090427154022.GA24244@kroah.com>
References: <200904261759.20923.bzolnier@gmail.com> <20090426183954.GA18449@kroah.com> <200904271728.33140.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904271728.33140.bzolnier@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 05:28:32PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 26 April 2009 20:39:54 Greg KH wrote:
> > On Sun, Apr 26, 2009 at 05:59:20PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > 
> > > Hi,
> > > 
> > > This patchset cleans up rt{286,287,307}0 drivers (66 KLOC removed) and then
> > > "dumb" (i.e. rt3070 shares code with rt2870 by including rt2870's .c files
> > > and depends on ifdefs to get the correct end result) merges them (142 KLOC
> > > removed).  All in all 208 KLOC are gone and we now use the common code for
> > > all three Ralink drivers.
> > 
> > Wonderful!
> > 
> > Were you able to test that this still works afterward?
> 
> I just used some semi-automatic verification of changes -- I scripted build
> process with comparing sizes of resulting .o files so when they were different
> I was re-auditing the given patch or (if re-audit didn't catch anything)
> comparing corresponding .s files.  This of course doesn't provide us with
> a complete proof that changes are correct but increases probability of such
> outcome significantly. :)

Heh :)

> The real testing with RT2860, RT2870 & RT3070 would be much welcomed...

Agreed.  I'll pull these into my tree and hopefully someone with the
hardware can test it out in linux-next.

Hm, wait, I think I have a laptop somewhere around here with one of
these devices, so I'll see if I can test it myself as well.

thanks,

greg k-h
