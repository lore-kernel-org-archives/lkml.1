Return-Path: <linux-kernel-owner+w=401wt.eu-S1762681AbXEPR4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762681AbXEPR4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbXEPR4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:56:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37202 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbXEPR4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:56:16 -0400
Date: Wed, 16 May 2007 18:56:00 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Message-ID: <20070516175600.GA3261@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Ben Fennema <bfennema@falcon.csc.calpoly.edu>
References: <20070510140000.GA12399@cvg> <20070510154640.c0299a52.akpm@linux-foundation.org> <20070511072939.GA25727@infradead.org> <20070511090127.GD9444@cvg> <20070511103956.GA30896@infradead.org> <20070511110920.GA11898@cvg> <20070513210126.GB14030@infradead.org> <20070516143308.GA8327@cvg> <20070516173852.GC29602@atrey.karlin.mff.cuni.cz> <20070516175257.GA14076@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516175257.GA14076@cvg>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 09:52:57PM +0400, Cyrill Gorcunov wrote:
> I've that documants even printed ;) Actually they are _very-very_ big
> indeed. I don't know may be just try to bring this code into Linux
> codying style?

That's probably a good step.  And while converting things to a proper
style you'll surely find various bugs and thinkgs you could improve.
Write them down somewhere and work on fixing them.  And make sure every
actualy fix or behaviour change is a single patch separated from the
cleanups.
