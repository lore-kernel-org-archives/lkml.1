Return-Path: <linux-kernel-owner+w=401wt.eu-S932778AbXK3Hri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbXK3Hri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 02:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758137AbXK3HrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 02:47:25 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45403 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754923AbXK3HrY (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 02:47:24 -0500
Date: Fri, 30 Nov 2007 18:47:12 +1100
From: David Chinner <dgc@sgi.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: revert to double-buffering readdir
Message-ID: <20071130074712.GM119954183@sgi.com>
References: <20071114070400.GA25708@puku.stupidest.org> <20071125163014.GA17922@infradead.org> <alpine.DEB.0.99999.0711300037520.9287@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99999.0711300037520.9287@sheep.housecafe.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 12:45:05AM +0100, Christian Kujau wrote:
> On Sun, 25 Nov 2007, Christoph Hellwig wrote:
> >This patch does exactly that and reverts xfs_file_readdir to what's
> >basically the 2.6.23 version minus the uio and vnops junk.
> 
> Thanks, works here too (without nordirplus as a mountoption).
> Am I supposed to close the bug[0] or do you guys want to leave this
> open to track the Real Fix (TM) for 2.6.25?

I've been giving the fix some QA - that change appears to have caused
a different regression as well so I'm holding off for a little bit
until we know what the cause of the other regression is before deciding
whether to take this fix or back the entire change out.

Either way we'll include the fix in 2.6.24....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
