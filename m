Return-Path: <linux-kernel-owner+w=401wt.eu-S932522AbZHLKs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbZHLKs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932468AbZHLKs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:48:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:54749 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbZHLKs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:48:28 -0400
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20090812094119.GC14734@elte.hu>
References: <Pine.LNX.4.44L0.0908111659510.5845-100000@iolanthe.rowland.org>
	 <20090812094119.GC14734@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Aug 2009 12:47:50 +0200
Message-Id: <1250074070.10001.33.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 11:41 +0200, Ingo Molnar wrote:
> * Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > This patch (as1279) adds kerneldoc for flush_scheduled_work()
> > containing a stern warning that the function should be avoided.
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

> >  
> > +/**
> > + * flush_scheduled_work - ensure that all work scheduled on keventd_wq has run to completion.

> > + */
> 
> Looks good - a small nit: please use proper/consistent line length, 
> something like:
> 
> /**
>  * flush_scheduled_work - ensure that all work scheduled on 
>  *			  keventd_wq has run to completion
>  *

>  */


And here I was thinking kerneldoc doesn't actually work like that, but
perhaps Randy fixed it so the initial description can line-wrap?
