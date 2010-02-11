Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab0BKPW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 10:22:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:29260 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab0BKPW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 10:22:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hAC0AUd2Vc9QTmJsi8S0mFd1Bd+nZFto4P1wnOi7HsNTO3jSNxX/f5JwPL/bYf/b8X
         A/dh2R+BVOyIU3BuM35ZPNdy44G5sQyD84kSrmt/Cx2srfmT+Y7fyRR8zUjF6Ikwf9t8
         LK+1KqnbmMmnSbn3JGZpT1wOH5LgQ0hqyt92U=
Date: Thu, 11 Feb 2010 18:22:20 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       paulus@samba.org
Subject: Re: [RFC perf,x86] P4 PMU early draft
Message-ID: <20100211152220.GA5385@lenovo>
References: <20100208184504.GB5130@lenovo> <20100209041739.GA11280@elte.hu> <20100209223909.GE5068@lenovo> <1265796732.11509.260.camel@laptop> <aa79d98a1002100238v256ca6daw5e00c8b6d8dc4bb6@mail.gmail.com> <1265799175.11509.271.camel@laptop> <1265890918.5396.3.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265890918.5396.3.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 01:21:58PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-02-10 at 11:52 +0100, Peter Zijlstra wrote:
> > which suggests we should simply remove that cpu argument 
> 
> The below patch does so for all in-tree bits.
> 
> Doing this patch reminded me of the mess that is
> hw_perf_group_sched_in(), so I'm going to try and fix that next.
> 

Yes Peter, thanks! At least for me this patch makes code more
understandable :)

	-- Cyrill
