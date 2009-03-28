Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbZC1ARS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbZC1ARS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZC1ARC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:17:02 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46540 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752448AbZC1ARA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:17:00 -0400
Date: Sat, 28 Mar 2009 00:14:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090328001432.5dd5f10f@lxorguk.ukuu.org.uk>
In-Reply-To: <49CD394B.9080903@garzik.org>
References: <20090324184549.GE32307@mit.edu>
	<alpine.LFD.2.00.0903241218130.3032@localhost.localdomain>
	<49C93AB0.6070300@garzik.org>
	<20090325093913.GJ27476@kernel.dk>
	<49CA86BD.6060205@garzik.org>
	<20090325194341.GB27476@kernel.dk>
	<49CA9346.6040108@garzik.org>
	<alpine.LFD.2.00.0903251337410.3032@localhost.localdomain>
	<20090327075723.GT27476@kernel.dk>
	<20090327141333.GS6239@mit.edu>
	<20090327143543.GA17541@infradead.org>
	<49CD394B.9080903@garzik.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 16:38:35 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Christoph Hellwig wrote:
> > And please add a tuneable for the flush.  Preferable a generic one at
> > the block device layer instead of the current mess where every
> > filesystem has a slightly different option for barrier usage.
> 
> At the very least, IMO the block layer should be able to notice when 
> barriers need not be translated into cache flushes.  Most notably when 
> wb cache is disabled on the drive, something easy to auto-detect, but 
> probably a manual switch also, for people with enterprise battery-backed 
> storage and such.

The storage drivers for those cases already generally know this and treat
cache flush requests as "has hit nvram", even the non enterprise ones.

