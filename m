Return-Path: <linux-kernel-owner+w=401wt.eu-S1761928AbYDZUXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761928AbYDZUXe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760113AbYDZUX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:23:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34785 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758518AbYDZUX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:23:26 -0400
Date: Sat, 26 Apr 2008 16:23:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Denys Vlasenko <vda.linux@googlemail.com>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Message-ID: <20080426202323.GA14245@infradead.org>
References: <200804261651.02078.vda.linux__2040.04651536724$1209223026$gmane$org@googlemail.com> <87iqy4wfjq.fsf@basil.nowhere.org> <20080426200701.GA10883@infradead.org> <20080426202630.GG17905@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426202630.GG17905@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 10:26:30PM +0200, Andi Kleen wrote:
> > STATIC as defined by xfs already does this..
> 
> Weird. Unexpected. Different from everyone else. Is this some exercise in 
> obfuscation?

The whole STATIC thing is weird to start with..

Yes, it's kinda unexpected and at least I don't particularly liked it.
But the inlining of functions with -funit-at-a-time was such a problem
for the stack useage in XFS that it got added as least horrible bandaid.

