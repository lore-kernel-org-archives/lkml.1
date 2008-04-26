Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYDZNpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYDZNpb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 09:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYDZNo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 09:44:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35051 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbYDZNo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 09:44:56 -0400
Date: Sat, 26 Apr 2008 09:44:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>, Daniel Walker <dwalker@mvista.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Announce: Semaphore-Removal tree
Message-ID: <20080426134430.GA28205@infradead.org>
References: <20080425170021.GH14990@parisc-linux.org> <1209155917.12461.46.camel@localhost.localdomain> <20080425211250.GA13858@infradead.org> <1209158552.12461.53.camel@localhost.localdomain> <20080426093048.GA11443@infradead.org> <1209217153.1956.14.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209217153.1956.14.camel@lappy>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 03:39:13PM +0200, Peter Zijlstra wrote:
> I'm guessing RCU would be a bit more work?

Actually the whole XFS inode hash is gone now and replaced by a radix tree.
As soon as nick and your work on the lockless radix trees goes in I'm
pretty sure Dave will make use of that.

