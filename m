Return-Path: <linux-kernel-owner+w=401wt.eu-S934175AbZKXVMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175AbZKXVMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934166AbZKXVMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:12:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:44570 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934157AbZKXVMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:12:37 -0500
Subject: Re: lockdep complaints in slab allocator
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Matt Mackall <mpm@selenic.com>, paulmck@linux.vnet.ibm.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <alpine.DEB.2.00.0911241302370.6593@chino.kir.corp.google.com>
References: <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com>
	 <1258709153.11284.429.camel@laptop>
	 <84144f020911200238w3d3ecb38k92ca595beee31de5@mail.gmail.com>
	 <1258714328.11284.522.camel@laptop> <4B067816.6070304@cs.helsinki.fi>
	 <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop>
	 <1259003425.17871.328.camel@calx> <4B0ADEF5.9040001@cs.helsinki.fi>
	 <1259080406.4531.1645.camel@laptop>
	 <20091124170032.GC6831@linux.vnet.ibm.com>
	 <1259082756.17871.607.camel@calx> <1259086459.4531.1752.camel@laptop>
	 <1259090615.17871.696.camel@calx>  <1259095580.4531.1788.camel@laptop>
	 <1259096004.17871.716.camel@calx> <1259096519.4531.1809.camel@laptop>
	 <alpine.DEB.2.00.0911241302370.6593@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 22:12:30 +0100
Message-ID: <1259097150.4531.1822.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 13:03 -0800, David Rientjes wrote:
> On Tue, 24 Nov 2009, Peter Zijlstra wrote:
> 
> > Merge SLQB and rm mm/sl[ua]b.c include/linux/sl[ua]b.h for .33-rc1
> > 
> 
> slqb still has a 5-10% performance regression compared to slab for 
> benchmarks such as netperf TCP_RR on machines with high cpu counts, 
> forcing that type of regression isn't acceptable.

Having _4_ slab allocators is equally unacceptable.

