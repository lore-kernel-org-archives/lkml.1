Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbZBSTAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbZBSTAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 14:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZBSTAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 14:00:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60087 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbZBSTAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 14:00:19 -0500
Date: Thu, 19 Feb 2009 14:00:09 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH 1/5] create fs flag to mark c/r supported fs's
Message-ID: <20090219190009.GC28490@infradead.org>
References: <20090219182007.B4B47C1F@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090219182007.B4B47C1F@kernel>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 10:20:07AM -0800, Dave Hansen wrote:
> 
> There are plenty of filesystems that are not supported for
> c/r at this point.  Think of things like hugetlbfs which
> are externally visible or pipefs which are kernel-internal.
> 
> This provides a quick way to make the "normal" filesystems
> which are currently supported.  This is also safe if any
> new code gets added.  We assume that a fs is non-supported
> unless someone takes explicit action to the contrary.
> 
> I bet there are some more filesystems that are OK, but
> these probably cover 99% of the users for now.

Given that a normal fs should be checkpointable you should
make those exposing internal state, not the other way around.

