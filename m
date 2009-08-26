Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbZHZBPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbZHZBPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbZHZBPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:15:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59363 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbZHZBPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:15:32 -0400
Date: Tue, 25 Aug 2009 21:15:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Simon Kirby <sim@hostway.ca>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30.4] XFS-related BUG and hang via shrink_icache_memory
Message-ID: <20090826011532.GA24362@infradead.org>
References: <20090826004658.GA30929@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826004658.GA30929@hostway.ca>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 05:46:58PM -0700, Simon Kirby wrote:
> On an NFS storage server, we started using some XFS filesystems along
> with many other EXT3 (on LVM on AOE).  The following bug has occurred
> twice, with the machine hanging immediately after (console full of
> scrolling oopses or bugs -- haven't seen it myself -- after this):

Known and fortunately fixed bug, get the patches to fix it from:

	http://bugzilla.kernel.org/attachment.cgi?id=22741

It should also be included in the next upcoming 2.6.30-stable release.

