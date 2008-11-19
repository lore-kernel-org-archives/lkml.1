Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbYKSTz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbYKSTz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYKSTzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:55:20 -0500
Received: from relay1.sgi.com ([192.48.179.29]:35713 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751863AbYKSTzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:55:19 -0500
Date: Wed, 19 Nov 2008 13:55:17 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and no load balance
Message-ID: <20081119195517.GB662@sgi.com>
References: <20081103210748.GC9937@sgi.com> <1225751603.7803.1640.camel@twins> <490FC735.1070405@novell.com> <49105D84.8070108@novell.com> <1225809393.7803.1669.camel@twins> <20081104144017.GB30855@sgi.com> <4910634C.1020207@novell.com> <49246DD0.3010509@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49246DD0.3010509@qualcomm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 11:49:36AM -0800, Max Krasnyansky wrote:
> I think the idea is that we want to make balancer a noop on those processors.

Ultimately, making the balancer a noop on processors with load balancing turned off would be the best solution.

> We could change cpusets code to create a root sched domain for each cpu I
> guess. But can we maybe scale cpupri some other way ?

It doesn't make sense to me that they'd have a root domain attached that spans more of the the system than that cpu.

> 
> Max
