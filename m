Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab0BRKI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 05:08:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60263 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab0BRKI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 05:08:56 -0500
Date: Thu, 18 Feb 2010 11:08:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Anton Blanchard <anton@samba.org>
Cc: Andi Kleen <andi@firstfloor.org>, arun@linux.vnet.ibm.com,
       tglx@linutronix.de, davem@davemloft.net, linux-kernel@vger.kernel.org,
       arjan@infradead.org, venkatesh.pallipadi@intel.com
Subject: Re: NO_HZ migration of TCP ack timers
Message-ID: <20100218100849.GD5964@basil.fritz.box>
References: <20100218052820.GD24270@kryten> <87mxz755ks.fsf@basil.nowhere.org> <20100218095529.GA31681@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100218095529.GA31681@kryten>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 08:55:30PM +1100, Anton Blanchard wrote:
> 
> Hi Andi,
> 
> > If the nohz balancer CPU is otherwise idle, shouldn't it have enough
> > cycles to handle acks for everyone? Is the problem the cache line
> > transfer time?
> 
> Yeah, I think the timer spinlock on the nohz balancer cpu ends up being a
> global lock for every other cpu trying to migrate their ack timers to it.

And they do that often for short idle periods?

For longer idle periods that should be not too bad.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
