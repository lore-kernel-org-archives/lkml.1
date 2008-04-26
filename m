Return-Path: <linux-kernel-owner+w=401wt.eu-S1762047AbYDZUHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762047AbYDZUHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759196AbYDZUHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:07:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44177 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758518AbYDZUHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:07:05 -0400
Date: Sat, 26 Apr 2008 16:07:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Message-ID: <20080426200701.GA10883@infradead.org>
References: <200804261651.02078.vda.linux__2040.04651536724$1209223026$gmane$org@googlemail.com> <87iqy4wfjq.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iqy4wfjq.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 10:02:17PM +0200, Andi Kleen wrote:
> Denys Vlasenko <vda.linux@googlemail.com> writes:
> >
> > Compile tested only.
> 
> You should mark the helper noinline just to prevent gcc from possibly
> inlining it. Even if it doesn't with your current compiler inline heuristics
> vary widely between compiler versions.

STATIC as defined by xfs already does this..

