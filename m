Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbYAJIzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbYAJIzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbYAJIzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:55:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57327 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbYAJIzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:55:02 -0500
Date: Thu, 10 Jan 2008 08:54:59 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       chris.mason@oracle.com, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080110085459.GA11966@infradead.org>
References: <20080109085231.GE6650@kernel.dk> <200801101242.25671.nickpiggin@yahoo.com.au> <20080110083753.GB10745@infradead.org> <20080110084457.GT6258@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110084457.GT6258@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 09:44:57AM +0100, Jens Axboe wrote:
> > IMHO this shouldn't be done in the loop driver anyway.  Filesystems have
> > their own effricient extent lookup trees (well, at least xfs and btrfs
> > do), and we should leverage that instead of reinventing it.
> 
> Completely agree, it's just needed right now for this solution since all
> we have is a crappy bmap() interface to get at those mappings.

So let's fix the interface instead of piling crap ontop of it.  As I
said I think Peter has something to start with so let's beat on it
until we have something suitable.   If we aren't done by end of Feb
I'm happy to host a hackfest to get it sorted around the fs/storage
summit..

