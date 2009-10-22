Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbZJVAoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbZJVAoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 20:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbZJVAoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 20:44:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44643 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbZJVAoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 20:44:22 -0400
Date: Thu, 22 Oct 2009 02:44:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Mike Fulton <fultonm@ca.ibm.com>, Sean Foley <Sean_Foley@ca.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
Message-ID: <20091022004426.GR32470@one.firstfloor.org>
References: <1256167297.4768.14.camel@localhost.localdomain> <20091022002853.GP32470@one.firstfloor.org> <1256172135.4768.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256172135.4768.19.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 05:42:15PM -0700, john stultz wrote:
> On Thu, 2009-10-22 at 02:28 +0200, Andi Kleen wrote:
> > On Wed, Oct 21, 2009 at 04:21:37PM -0700, john stultz wrote:
> > > 
> > > Taking a very raw attempt at this, I scratched out the following simple
> > > implementation. I'd appreciate any review or suggestions for
> > > improvements. I'm not at all certain the passing of the thread pid_t
> > > through the unsigned long is valid, for instance, or if
> > > same_thread_group() is the right check to make sure we only change
> > > siblings and not tid from other processes. So any advice on better
> > > approaches would be great.
> > 
> > First though that comes to mind is that this should not be in prctl()
> 
> So it deserves a new syscall? Any other thoughts?

I would probably just put it into /proc/pid and use the normal ptrace
access checks.
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
