Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYJ3WD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYJ3WD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYJ3WDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:03:50 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:24736 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbYJ3WDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:03:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAGXJCUl5LIvD/2dsb2JhbADMS4NR
X-IronPort-AV: E=Sophos;i="4.33,518,1220193000"; 
   d="scan'208";a="244383539"
Date: Fri, 31 Oct 2008 09:03:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       Paul Menage <menage@google.com>, Derek Fults <dfults@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] cpuset writeback throttling
Message-ID: <20081030220344.GL4985@disturbed>
Mail-Followup-To: Christoph Lameter <cl@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@suse.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Paul Menage <menage@google.com>, Derek Fults <dfults@sgi.com>,
	linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com> <20081030210826.GR17077@disturbed> <Pine.LNX.4.64.0810301632030.3839@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810301632030.3839@quilx.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 04:33:34PM -0500, Christoph Lameter wrote:
> On Fri, 31 Oct 2008, Dave Chinner wrote:
>
>> What sort of validation/regression testing has this been through?
>
> There were several tests run more than a year ago by me on large SGI  
> machines. Then there was Solomita who did various tests and posts of the 
> patchset over the last year.

Yes, I know about those tests at SGI - they were to demonstrate the
feature worked (i.e. proof-of-concept demonstration), not regression
test the change.

This is a fairly major change in behaviour to the writeback path on
NUMA systems and so has the potential to introduce subtle new
issues. Hence I'm asking about the level of testing and exposure
it has had. It doesn't really sound like it has had much coverage
to me....

I'm concerned right now because Nick and others (including myself)
have recently found lots of nasty data integrity problems in the
writeback path that we are currently trying to test fixes for.
It's not a good time to introduce new behaviours as that will
definitely perturb any regression testing we are running....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
