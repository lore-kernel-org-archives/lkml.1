Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbXKUEro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbXKUEro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 23:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbXKUErg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 23:47:36 -0500
Received: from relay1.sgi.com ([192.48.171.29]:33864 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752063AbXKUErf (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 23:47:35 -0500
Date: Wed, 21 Nov 2007 15:47:11 +1100
From: David Chinner <dgc@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, ak@suse.de,
       akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 18/45] cpu alloc: XFS counters
Message-ID: <20071121044711.GF995458@sgi.com>
References: <20071120011132.143632442@sgi.com> <20071120011335.975705216@sgi.com> <20071120081230.GA1324@infradead.org> <Pine.LNX.4.64.0711201238010.26745@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711201238010.26745@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 12:38:29PM -0800, Christoph Lameter wrote:
> On Tue, 20 Nov 2007, Christoph Hellwig wrote:
> 
> > On Mon, Nov 19, 2007 at 05:11:50PM -0800, clameter@sgi.com wrote:
> > > Also remove the useless zeroing after allocation. Allocpercpu already
> > > zeroed the objects.
> > 
> > You still haven't answered my comment to the last iteration.
> 
> And you have not read the discussion on that subject in the prior 
> iteration between Peter Zilkstra and me.

Seeing as I didn't notice this patchest changed XFS (where's the cc?)
until I saw hch's question I'd appreciate a pointer to that discussion
as it's long been deleted from my mailbox.

FWIW, I happen to agree with Christoph (hch) that the shouting
macros are an ugly step backwards, esp. given that is replacing:

#define per_cpu_ptr(ptr, cpu)   percpu_ptr((ptr), (cpu))

a set of lowercase macros....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
