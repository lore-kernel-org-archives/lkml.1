Return-Path: <linux-kernel-owner+w=401wt.eu-S1760613AbXEUINH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613AbXEUINH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbXEUIMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:12:46 -0400
Received: from styx.suse.cz ([82.119.242.94]:51746 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756618AbXEUIMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:12:45 -0400
Date: Mon, 21 May 2007 10:23:49 +0200
From: Jan Kara <jack@suse.cz>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Message-ID: <20070521082349.GB30684@duck.suse.cz>
References: <20070511072939.GA25727@infradead.org> <20070511090127.GD9444@cvg> <20070511103956.GA30896@infradead.org> <20070511110920.GA11898@cvg> <20070513210126.GB14030@infradead.org> <20070516143308.GA8327@cvg> <20070516173852.GC29602@atrey.karlin.mff.cuni.cz> <20070516175257.GA14076@cvg> <20070516175600.GA3261@infradead.org> <20070520122010.GA8334@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070520122010.GA8334@cvg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 20-05-07 16:20:10, Cyrill Gorcunov wrote:
> [Christoph Hellwig - Wed, May 16, 2007 at 06:56:00PM +0100]
> | On Wed, May 16, 2007 at 09:52:57PM +0400, Cyrill Gorcunov wrote:
> | > I've that documants even printed ;) Actually they are _very-very_ big
> | > indeed. I don't know may be just try to bring this code into Linux
> | > codying style?
> | 
> | That's probably a good step.  And while converting things to a proper
> | style you'll surely find various bugs and thinkgs you could improve.
> | Write them down somewhere and work on fixing them.  And make sure every
> | actualy fix or behaviour change is a single patch separated from the
> | cleanups.
> | 
> 
> Hi Christoph,
> 
> I almost have completed UDF style conversation (the only thing to do
> is to check all I've changed). And I've been striked down by the simple
> question: the conversion I've done is over 2.6.22-rc1 but meantime in -mm
> tree two my patches already exist so should I take them into account while
> converting UDF style?
  I guess Andrew would be most grateful if you counted with these two
patches...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
