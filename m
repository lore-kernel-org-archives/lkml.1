Return-Path: <linux-kernel-owner+w=401wt.eu-S1762844AbXEUKgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762844AbXEUKgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758294AbXEUKgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:36:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38279 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906AbXEUKgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:36:13 -0400
Date: Mon, 21 May 2007 11:36:05 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Message-ID: <20070521103605.GA13202@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Ben Fennema <bfennema@falcon.csc.calpoly.edu>
References: <20070511072939.GA25727@infradead.org> <20070511090127.GD9444@cvg> <20070511103956.GA30896@infradead.org> <20070511110920.GA11898@cvg> <20070513210126.GB14030@infradead.org> <20070516143308.GA8327@cvg> <20070516173852.GC29602@atrey.karlin.mff.cuni.cz> <20070516175257.GA14076@cvg> <20070516175600.GA3261@infradead.org> <20070520122010.GA8334@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070520122010.GA8334@cvg>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 04:20:10PM +0400, Cyrill Gorcunov wrote:
> I almost have completed UDF style conversation (the only thing to do
> is to check all I've changed). And I've been striked down by the simple
> question: the conversion I've done is over 2.6.22-rc1 but meantime in -mm
> tree two my patches already exist so should I take them into account while
> converting UDF style?

It's probably best if you do that patch ontop of -mm so it includes
your patches.


