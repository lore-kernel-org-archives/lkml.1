Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbZKETLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbZKETLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757932AbZKETLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:11:05 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:32961 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757896AbZKETLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:11:04 -0500
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
From: john stultz <johnstul@us.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Darren Hart <dvhltc@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Mike Fulton <fultonm@ca.ibm.com>, Sean Foley <Sean_Foley@ca.ibm.com>
In-Reply-To: <20091105143959.2093.A69D9226@jp.fujitsu.com>
References: <20091105141953.2090.A69D9226@jp.fujitsu.com>
	 <4AF26471.6010705@us.ibm.com> <20091105143959.2093.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Nov 2009 11:11:15 -0800
Message-ID: <1257448275.3923.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-05 at 14:42 +0900, KOSAKI Motohiro wrote:
> > KOSAKI Motohiro wrote:
> > >> KOSAKI Motohiro wrote:
> > >>
> > >>> John, I'd prefer to suggested another design.
> > >>> How about this?
> > >>>
> > >>> 1. remove pid argument from prctl
> > >>> 2. cancel pthread_setname_np()
> > >>> 3. instead, create pthread_attr_setname_np()
> > >>> 4. pthread_create() change own thread name by pthread_attr.
> > >>>
> > >>> It avoid many racy problem automatically.
> > >> Perhaps, but it also greatly reduces the flexibility of the 
> > >> implementation by restricting name changes to create time.
> > > 
> > > Hm.
> > > if your program really need to change another thread name, can you please tell us
> > > why it is necessary and when it is used?
> > 
> > I think John's previous mails covered that pretty well. As for doing the 
> > name change at create time, or sometime later, it just seems to me that 
> > the flexibility of doing so later is worth having. While I know we don't 
> > have to follow other systems implementations, in this case 
> > pthread_setname_np() seems a reasonable model to follow to me.
> 
> You only said your mode is more flexible. but I want to know _why_ this flexibiliby is
> necessay. please tell us concrete use-case.

You can read Sean's example from this thread here:
	http://lkml.org/lkml/2009/10/27/259

thanks
-john


