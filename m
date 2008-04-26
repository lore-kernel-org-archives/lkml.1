Return-Path: <linux-kernel-owner+w=401wt.eu-S1761529AbYDZUUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761529AbYDZUUi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758309AbYDZUUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:20:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49172 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810AbYDZUUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:20:30 -0400
Date: Sat, 26 Apr 2008 22:26:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Denys Vlasenko <vda.linux@googlemail.com>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Message-ID: <20080426202630.GG17905@one.firstfloor.org>
References: <200804261651.02078.vda.linux__2040.04651536724$1209223026$gmane$org@googlemail.com> <87iqy4wfjq.fsf@basil.nowhere.org> <20080426200701.GA10883@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426200701.GA10883@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 04:07:01PM -0400, Christoph Hellwig wrote:
> On Sat, Apr 26, 2008 at 10:02:17PM +0200, Andi Kleen wrote:
> > Denys Vlasenko <vda.linux@googlemail.com> writes:
> > >
> > > Compile tested only.
> > 
> > You should mark the helper noinline just to prevent gcc from possibly
> > inlining it. Even if it doesn't with your current compiler inline heuristics
> > vary widely between compiler versions.
> 
> STATIC as defined by xfs already does this..

Weird. Unexpected. Different from everyone else. Is this some exercise in 
obfuscation?

But ok.

-Andi
