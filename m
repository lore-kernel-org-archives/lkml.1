Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbZJAJXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbZJAJXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbZJAJXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:23:12 -0400
Received: from mail09.linbit.com ([212.69.161.110]:47862 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbZJAJXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:23:11 -0400
Date: Thu, 1 Oct 2009 11:23:14 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block updates for 2.6.32-rc
Message-ID: <20091001092314.GC8018@barkeeper1-xen.linbit>
References: <20090930174109.GD14918@kernel.dk> <20090930193911.GA14391@infradead.org> <20091001070549.GI14918@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091001070549.GI14918@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 09:05:49AM +0200, Jens Axboe wrote:
> On Wed, Sep 30 2009, Christoph Hellwig wrote:
> > On Wed, Sep 30, 2009 at 07:41:10PM +0200, Jens Axboe wrote:
> > > Hi Linus,
> > > 
> > > This looks huge, but it's mostly a cciss driver update and the addition
> > > of drbd. I would have submitted this before -rc1, but Plumbers got in
> > > the way.
> > 
> > And DRBD is defintively not ready.  Even if people want to merge another
> > duplicate RAID driver including another crappy user interface it has
> > tracing stuff of a form that would let Ingo go beserk and also uses the
> > stupid connector.
> 
> Can we get rid of the connector? Didn't look very closely, but looks
> kinda stuck with it. I killed the tracing bits, agree on that.

Thanks for killing the tracing bits ;)
We might add trace_events at appropriate places later,
once we need them again.

Getting rid of the connector: If we have to, the easiest way for us
would be to switch to genetlink.  I can prepare such a change.

-- 
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD® and LINBIT® are registered trademarks of LINBIT, Austria.
