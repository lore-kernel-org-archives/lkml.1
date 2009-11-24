Return-Path: <linux-kernel-owner+w=401wt.eu-S932427AbZKXJPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbZKXJPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932402AbZKXJPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:15:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:1044 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388AbZKXJPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:15:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,276,1257148800"; 
   d="scan'208";a="572578458"
Subject: Re: [PATCH] irq: Add node_affinity CPU masks for smarter
 irqbalance hints
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1259053736.4531.1097.camel@laptop>
References: <20091123064630.7385.30498.stgit@ppwaskie-hc2.jf.intel.com>
	 <2674af740911222332i65c0d066h79bf2c1ca1d5e4f0@mail.gmail.com>
	 <1258968980.2697.9.camel@ppwaskie-mobl2> <1258995923.4531.715.camel@laptop>
	 <Pine.WNT.4.64.0911231529240.10056@ppwaskie-MOBL2.amr.corp.intel.com>
	 <1259051902.4531.1053.camel@laptop>
	 <1259053156.2631.21.camel@ppwaskie-mobl2>
	 <1259053736.4531.1097.camel@laptop>
Content-Type: text/plain
Date: Tue, 24 Nov 2009 01:15:22 -0800
Message-Id: <1259054122.2631.31.camel@ppwaskie-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 02:08 -0700, Peter Zijlstra wrote:
> On Tue, 2009-11-24 at 00:59 -0800, Peter P Waskiewicz Jr wrote:
> > > This all sounds backwards.. we've got a perfectly functional interface
> > > for affinity -- which people object to being used for some reason. So
> > > you add another interface on top, and that is ok?
> > > 
> > 
> > But it's not functional.  If I set the affinity in smp_affinity, then
> > irqbalance will override it 10 seconds later. 
> 
> And here I was thinking the kernel round-robins IRQ delivery on the mask
> specified there. Are you talking about some daft userspace thing that
> writes into the irq smp_affinity to effect irq balancing?
> 

Yep.  That's exactly what irqbalance does.

Cheers,
-PJ

