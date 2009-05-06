Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbZEFT0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbZEFT0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 15:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbZEFT0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 15:26:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755638AbZEFT0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 15:26:36 -0400
Date: Wed, 6 May 2009 12:19:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: mingo@elte.hu, dhowells@redhat.com, linux-kernel@vger.kernel.org,
       niv@us.ibm.com, dvhltc@us.ibm.com, lethal@linux-sh.org,
       kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v4 RCU: the bloatwatch edition
Message-Id: <20090506121908.1fcd3afc.akpm@linux-foundation.org>
In-Reply-To: <20090506190216.GE6771@linux.vnet.ibm.com>
References: <20090502163423.GA1633@linux.vnet.ibm.com>
	<20090506112459.5edd0902.akpm@linux-foundation.org>
	<20090506190216.GE6771@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009 12:02:16 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> > > i'm wondering what Andrew thinks - he had objections, right?
> > > 
> > 
> > More like "concerns".  It's unobvious to me that the modest .text
> > savings justify the costs of an additional RCU implementation.  Where
> > those costs include
> > 
> > - additional maintenance work and
> > 
> > - the reduced code reliability which comes from fragmenting the
> >   tester base.  This will mostly affect users of the less popular RCU
> >   implementations.
> > 
> > But hey, maybe I'm wrong.  And maybe I'm right, but we'll merge it anyway ;)
> 
> ;-)
> 
> How about if acceptance of Tiny RCU happens at the same time as Classic
> RCU is dropped?  That would be a large net decrease in code size and
> complexity.

It's a bit artificial to link the two actions.  Removing something:
good.  Adding something: bad.  good+bad == less good ;)
