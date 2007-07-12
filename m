Return-Path: <linux-kernel-owner+w=401wt.eu-S935622AbXGLCba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935622AbXGLCba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 22:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763584AbXGLCbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 22:31:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58615 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758128AbXGLCbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 22:31:18 -0400
Date: Thu, 12 Jul 2007 12:31:00 +1000
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux Memory Management <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       xfs-oss <xfs@oss.sgi.com>
Subject: block_page_mkwrite? (Re: fault vs invalidate race (Re: -mm merge plans for 2.6.23))
Message-ID: <20070712023100.GX12413810@sgi.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <46957BE1.1010104@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46957BE1.1010104@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 10:54:57AM +1000, Nick Piggin wrote:
> Andrew Morton wrote:
> > The fault-vs-invalidate race fix.  I have belatedly learned that these 
> > need
> > more work, so their state is uncertain.
> 
> The more work may turn out being too much for you (although it is nothing
> exactly tricky that would introduce subtle bugs, it is a fair amont of 
> churn).

OK, so does that mean we can finally get the block_page_mkwrite
patches merged?

i.e.:

http://marc.info/?l=linux-kernel&m=117426058311032&w=2
http://marc.info/?l=linux-kernel&m=117426070111136&w=2

I've got up-to-date versions of them ready to go and they've been
consistently tested thanks to the XFSQA test I wrote for the bug
that it fixes. I've been holding them out-of-tree for months now
because ->fault was supposed to supercede this interface.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
