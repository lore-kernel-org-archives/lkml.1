Return-Path: <linux-kernel-owner+w=401wt.eu-S1761302AbXKUPIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761302AbXKUPIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 10:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbXKUPHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 10:07:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59606 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbXKUPHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 10:07:52 -0500
Date: Wed, 21 Nov 2007 15:07:46 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Wedgwood <cw@f00f.org>,
       linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc2 XFS nfsd hang
Message-ID: <20071121150746.GB8454@infradead.org>
References: <20071114070400.GA25708@puku.stupidest.org> <20071114152952.GA4210@infradead.org> <20071114173922.GC14254@fieldses.org> <20071114174419.GA15271@infradead.org> <20071114175322.GD14254@fieldses.org> <20071114180241.GA16656@infradead.org> <20071114180838.GE14254@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114180838.GE14254@fieldses.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 01:08:38PM -0500, J. Bruce Fields wrote:
> > Personally I'd prefer it to only grow a struct stat or rather it's members
> > But the nfsd code currently expects a dentry so this might require some
> > major refactoring.
> 
> Well, we need to check for mountpoints, for example, so I don't see any
> way out of needing a dentry.  What's the drawback?

You're right - we'd probably need the dentry.  The drawback is that
we need to always get it in the dcache.  Which might be a good thing
depending on the workload.

