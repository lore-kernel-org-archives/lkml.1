Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901AbYIKFRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbYIKFRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 01:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbYIKFRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 01:17:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41634 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbYIKFRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 01:17:38 -0400
Date: Thu, 11 Sep 2008 07:21:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC] CPUMASK: proposal for replacing cpumask_t
Message-ID: <20080911052125.GM7714@one.firstfloor.org>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com> <20080906235037.880702000@polaris-admin.engr.sgi.com> <1220783087.8687.73.camel@twins.programming.kicks-ass.net> <48C53C91.70604@sgi.com> <1220886335.12278.31.camel@twins.programming.kicks-ass.net> <20080908183852.GA3713@elte.hu> <48C84E9E.7080507@sgi.com> <20080910225345.GL7714@one.firstfloor.org> <48C8593C.9080801@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C8593C.9080801@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 04:33:16PM -0700, Mike Travis wrote:
> Andi Kleen wrote:
> >> Here's an initial proposal for abstracting cpumask_t to be either
> > 
> > At least for some cases I don't think you'll get around defining
> > a "nearby subset of CPUs that can be handled together" type. Handling 1K 
> > objects all the time in one piece is simply not a good idea.
> > 
> > -Andi
> 
> 
> Every time I stop to think about this, the problems with the cpu
> operators come to mind.  Should there be a separate set?  Or simply
> conversion functions to/from a "cpumask_subset" type?  

A subset would be hopefully enough (set/isset etc.) plus conversion
operators.

-Andi

-- 
ak@linux.intel.com
