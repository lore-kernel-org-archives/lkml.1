Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbZJVAm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbZJVAm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 20:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZJVAm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 20:42:26 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54263 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbZJVAmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 20:42:25 -0400
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
From: john stultz <johnstul@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Mike Fulton <fultonm@ca.ibm.com>,
       Sean Foley <Sean_Foley@ca.ibm.com>, Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <20091022002853.GP32470@one.firstfloor.org>
References: <1256167297.4768.14.camel@localhost.localdomain>
	 <20091022002853.GP32470@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 21 Oct 2009 17:42:15 -0700
Message-Id: <1256172135.4768.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 02:28 +0200, Andi Kleen wrote:
> On Wed, Oct 21, 2009 at 04:21:37PM -0700, john stultz wrote:
> > 
> > Taking a very raw attempt at this, I scratched out the following simple
> > implementation. I'd appreciate any review or suggestions for
> > improvements. I'm not at all certain the passing of the thread pid_t
> > through the unsigned long is valid, for instance, or if
> > same_thread_group() is the right check to make sure we only change
> > siblings and not tid from other processes. So any advice on better
> > approaches would be great.
> 
> First though that comes to mind is that this should not be in prctl()

So it deserves a new syscall? Any other thoughts?

thanks
-john

