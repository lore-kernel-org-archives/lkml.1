Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbXDZBPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbXDZBPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 21:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbXDZBPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 21:15:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57075 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754347AbXDZBPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 21:15:03 -0400
Date: Thu, 26 Apr 2007 11:14:49 +1000
From: David Chinner <dgc@sgi.com>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: clameter@sgi.com, lkml <linux-kernel@vger.kernel.org>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426011449.GI65285596@melbourne.sgi.com>
References: <20070424222105.883597089@sgi.com> <1177541179.32569.2.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177541179.32569.2.camel@dyn9047017100.beaverton.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 03:46:19PM -0700, Badari Pulavarty wrote:
> On Tue, 2007-04-24 at 15:21 -0700, clameter@sgi.com wrote:
> > V2->V3
> 
> Hmm.. It broke ext2 :(
> 
> V2 worked fine with the small fix I sent you earlier.
> But on V3, I can't run fsx. I see random data showing up.
> I will debug, when I get a chance.

Same thing on XFS - 'fsx -d -S 42 -R -W foobar' fails on
the tenth operation....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
