Return-Path: <linux-kernel-owner+w=401wt.eu-S1760480AbXEJItz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760480AbXEJItz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760098AbXEJItn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:49:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37999
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760277AbXEJItm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:49:42 -0400
Date: Thu, 10 May 2007 01:49:44 -0700 (PDT)
Message-Id: <20070510.014944.41634852.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 2/3] Add hard_irq_disable()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1178786505.14928.225.camel@localhost.localdomain>
References: <1178778951.14928.215.camel@localhost.localdomain>
	<20070510003528.395b122b.akpm@linux-foundation.org>
	<1178786505.14928.225.camel@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 10 May 2007 18:41:45 +1000

> 
> > > What about my comment layout style ? I've been using that forever ... Or
> > > do you mean I should use a function documentation style layout there ?
> > 
> > /* This
> >  * is
> >  * wrong
> >  */
> > 
> > /*
> >  * This
> >  * is
> >  * right
> >  */
> 
> Hrm... how bad are you about that one ? I must say I prefer my style :-)

I think the "wrong" one is right because screen real-estate matters.
In fact that's the one I use and enforce throughout the networking
and sparc ports.

I even hand edit out those empty comment lines in patches submitted
to me when I spot them.
