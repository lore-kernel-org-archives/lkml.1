Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbZJVAwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbZJVAwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 20:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbZJVAwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 20:52:36 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58689 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbZJVAwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 20:52:36 -0400
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
From: john stultz <johnstul@us.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Mike Fulton <fultonm@ca.ibm.com>, Sean Foley <Sean_Foley@ca.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <20091021174804.3885db37@infradead.org>
References: <1256167297.4768.14.camel@localhost.localdomain>
	 <20091021174804.3885db37@infradead.org>
Content-Type: text/plain
Date: Wed, 21 Oct 2009 17:52:24 -0700
Message-Id: <1256172744.4768.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 17:48 -0700, Arjan van de Ven wrote:
> On Wed, 21 Oct 2009 16:21:37 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> 
> > 
> > Taking a very raw attempt at this, I scratched out the following
> > simple implementation. I'd appreciate any review or suggestions for
> > improvements. I'm not at all certain the passing of the thread pid_t
> > through the unsigned long is valid, for instance, or if
> > same_thread_group() is the right check to make sure we only change
> > siblings and not tid from other processes. So any advice on better
> > approaches would be great.
> > 
> > +				return -EINVAL;
> > +
> > +			set_task_comm(tsk, comm);
> 
> 
> you're pretty much the first now who touches ->comm from
> not-the-thread-itself.... are you sure that is safe?

No, I'm not sure at all :)

Thanks for pointing this out. I'll see whats needed in set_task_comm().

thanks again
-john


