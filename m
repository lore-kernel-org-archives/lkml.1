Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbZLULdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbZLULdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 06:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517AbZLULdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 06:33:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56833 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387AbZLULdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 06:33:03 -0500
Date: Mon, 21 Dec 2009 12:33:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
       torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net
Subject: Re: workqueue thing
Message-ID: <20091221113301.GG25372@basil.fritz.box>
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box> <4B2B9949.1000608@linux.intel.com> <20091221091754.GG4489@kernel.dk> <20091221110929.GF25372@basil.fritz.box> <4B2F592C.4000504@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2F592C.4000504@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Also the nice thing about dynamically sizing the thread pool
>> is that if something bad (error condition that takes long) happens
>> in one work queue for a specific subsystem there's still a chance
>> to make process with other operations in the same subsystem.
>
> yup
> same is true for hitting some form of contention; just make an extra thread
> so that the rest can continue.

If you dynamically increase you can/should as well dynamically shrink too.
And with some more gimmicks you're nearly at what Tejun is proposing

Not sure what you're arguing against?

-Andi
>

-- 
ak@linux.intel.com -- Speaking for myself only.
