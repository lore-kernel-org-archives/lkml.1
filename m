Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbZAGCRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbZAGCRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 21:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758052AbZAGCRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 21:17:03 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:47015 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755941AbZAGCRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 21:17:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEFAGufY0l5LDnl/2dsb2JhbACDHMw0hXU
X-IronPort-AV: E=Sophos;i="4.37,223,1231075800"; 
   d="scan'208";a="288070453"
Date: Wed, 7 Jan 2009 13:16:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dmitri Monakhov <dmonakhov@openvz.org>
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090107021654.GD9448@disturbed>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Dmitri Monakhov <dmonakhov@openvz.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106150855.5f362a2d.akpm@linux-foundation.org> <20090106232208.GA25103@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106232208.GA25103@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 06:22:08PM -0500, Christoph Hellwig wrote:
> On Tue, Jan 06, 2009 at 03:08:55PM -0800, Andrew Morton wrote:
> > > Btw, this code is still not quite right.  We really need to call
> > > ->setattr instead of vmtruncate here.  Complex filesystem need
> > > transaction to properly free blocks, and those transactions are in
> > > ->setattr not inside vmtruncate where ->truncate doesn't even have
> > > a chance to get the handle to the transaction passed.
> > > 
> > > As these patches don't make it worse this is not a NACK, but more of
> > > a heads up.
> > 
> > Sure.  Maybe add a FIXME comment for now?
> 
> Ok.  I was planning to look into this again, and IIRC Dave already did
> when he was at SGI, but his proof of concept patches got lost somewhere.

Hmmmm - I think I posted the "it works for XFs but nothing else" POC
patches to fsdevel when I first found this....

<rummage>

http://marc.info/?l=linux-fsdevel&m=120952722315259&w=2

The thread starts here for those that want the whole story:

http://marc.info/?l=linux-fsdevel&m=120946361527726&w=2

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
