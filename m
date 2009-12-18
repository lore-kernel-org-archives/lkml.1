Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbZLRNul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbZLRNul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZLRNuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:50:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58767 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbZLRNuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:50:39 -0500
Date: Fri, 18 Dec 2009 14:50:33 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
Message-ID: <20091218135033.GB8678@basil.fritz.box>
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261143924.20899.169.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The only way something can be not cpu intensive and long 'running' is if
> it got blocked that long, and the right solution is to fix that
> contention, things should not be blocked for seconds.

Work queue items shouldn't be blocking for seconds in the normal case, but it might
always happen in the exceptional case (e.g. handling some error condition).
In this case it would be good if the other jobs wouldn't be too 
disrupted and the whole setup degrades gracefully.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
