Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbZFZIpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbZFZIpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZFZIpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:45:13 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55631 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbZFZIpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:45:12 -0400
Subject: Re: [PATCH RFC] fix RCU-callback-after-kmem_cache_destroy problem
 in sl[aou]b
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: paulmck@linux.vnet.ibm.com
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, cl@linux-foundation.org, jdb@comx.dk,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20090625220837.GD8852@linux.vnet.ibm.com>
References: <20090625193137.GA16861@linux.vnet.ibm.com>
	 <1245965239.21085.393.camel@calx>
	 <20090625220837.GD8852@linux.vnet.ibm.com>
Date: Fri, 26 Jun 2009 11:45:13 +0300
Message-Id: <1246005913.27533.21.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 15:08 -0700, Paul E. McKenney wrote:
> On Thu, Jun 25, 2009 at 04:27:19PM -0500, Matt Mackall wrote:
> > On Thu, 2009-06-25 at 12:31 -0700, Paul E. McKenney wrote:
> > > Hello!
> > > 
> > > Jesper noted that kmem_cache_destroy() invokes synchronize_rcu() rather
> > > than rcu_barrier() in the SLAB_DESTROY_BY_RCU case, which could result
> > > in RCU callbacks accessing a kmem_cache after it had been destroyed.
> > > 
> > > The following untested (might not even compile) patch proposes a fix.
> > 
> > Acked-by: Matt Mackall <mpm@selenic.com>
> > 
> > Nick, you'll want to make sure you get this in SLQB.
> > 
> > > Reported-by: Jesper Dangaard Brouer <jdb@comx.dk>
> 
> And I seem to have blown Jesper's email address (apologies, Jesper!), so:
> 
> Reported-by: Jesper Dangaard Brouer <hawk@comx.dk>

Compiles and boots here so I went ahead and applied the patch. ;) Thanks
a lot Paul!

			Pekka

