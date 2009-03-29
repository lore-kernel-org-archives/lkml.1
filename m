Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbZC2I1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbZC2I1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 04:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZC2I1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 04:27:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37127 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZC2I1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 04:27:16 -0400
Date: Sun, 29 Mar 2009 04:25:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090329082557.GB4242@infradead.org>
References: <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090327075723.GT27476@kernel.dk> <20090327141333.GS6239@mit.edu> <20090327143543.GA17541@infradead.org> <49CD394B.9080903@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CD394B.9080903@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 04:38:35PM -0400, Jeff Garzik wrote:
> At the very least, IMO the block layer should be able to notice when  
> barriers need not be translated into cache flushes.  Most notably when  
> wb cache is disabled on the drive, something easy to auto-detect, but  
> probably a manual switch also, for people with enterprise battery-backed  
> storage and such.

Yeah, that's why I suggested to have the tuning knob in the block layer
and not in the fses when this came up last time.

