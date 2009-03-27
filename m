Return-Path: <linux-kernel-owner+w=401wt.eu-S1760585AbZC0Uj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585AbZC0Uj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbZC0UjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:39:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53162 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbZC0UjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:39:18 -0400
Message-ID: <49CD394B.9080903@garzik.org>
Date: Fri, 27 Mar 2009 16:38:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090327075723.GT27476@kernel.dk> <20090327141333.GS6239@mit.edu> <20090327143543.GA17541@infradead.org>
In-Reply-To: <20090327143543.GA17541@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> And please add a tuneable for the flush.  Preferable a generic one at
> the block device layer instead of the current mess where every
> filesystem has a slightly different option for barrier usage.

At the very least, IMO the block layer should be able to notice when 
barriers need not be translated into cache flushes.  Most notably when 
wb cache is disabled on the drive, something easy to auto-detect, but 
probably a manual switch also, for people with enterprise battery-backed 
storage and such.

	Jeff


