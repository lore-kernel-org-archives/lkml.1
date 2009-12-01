Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbZLAQsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbZLAQsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbZLAQsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:48:11 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:35913 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbZLAQsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:48:06 -0500
Date: Tue, 1 Dec 2009 10:47:44 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
In-Reply-To: <alpine.DEB.2.00.0911301512250.12038@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0912011045200.9896@router.home>
References: <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com> <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop> <1259003425.17871.328.camel@calx> <4B0ADEF5.9040001@cs.helsinki.fi> <1259080406.4531.1645.camel@laptop>
 <20091124170032.GC6831@linux.vnet.ibm.com> <1259082756.17871.607.camel@calx> <1259086459.4531.1752.camel@laptop> <1259090615.17871.696.camel@calx> <84144f020911241307u14cd2cf0h614827137e42378e@mail.gmail.com> <1259103315.17871.895.camel@calx>
 <alpine.DEB.2.00.0911251356130.11347@chino.kir.corp.google.com> <alpine.DEB.2.00.0911271127130.20368@router.home> <alpine.DEB.2.00.0911301512250.12038@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, David Rientjes wrote:

> Right, but the user is still left with a decision of which slab allocator
> to compile into their kernel, each with distinct advantages and
> disadvantages that get exploited for the wide range of workloads that it
> runs.  If slob could be merged into another allocator, it would be simple
> to remove the distinction of it being seperate altogether, the differences
> would depend on CONFIG_EMBEDDED instead.

No embedded folks that I know are using SLOB. CONFIG_EMBEDDED still would
require a selection of allocators. I have no direct knowledge of anyone
using SLOB (despite traveling widely this year) aside from what Matt tells
me.

