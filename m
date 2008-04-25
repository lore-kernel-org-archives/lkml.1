Return-Path: <linux-kernel-owner+w=401wt.eu-S1764495AbYDYVNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764495AbYDYVNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 17:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759929AbYDYVM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 17:12:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759080AbYDYVM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 17:12:57 -0400
Date: Fri, 25 Apr 2008 17:12:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Announce: Semaphore-Removal tree
Message-ID: <20080425211250.GA13858@infradead.org>
References: <20080425170021.GH14990@parisc-linux.org> <1209155917.12461.46.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209155917.12461.46.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 01:38:37PM -0700, Daniel Walker wrote:
> I was reviewing your patches, and I don't like the semaphore to spinlock
> changes.. There's no reason to start adding spinlocks, unless it's
> really performance sensitive which none of those places are.. 

Yes, there is.  The spinlock is our most efficient locking primitive
for the normal mostly un-contentded case.  Please get out of your
realtime-ghetto.

