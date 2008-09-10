Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbYIJXd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbYIJXd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYIJXdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:33:20 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53819 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751989AbYIJXdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:33:19 -0400
Message-ID: <48C8593C.9080801@sgi.com>
Date: Wed, 10 Sep 2008 16:33:16 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC] CPUMASK: proposal for replacing cpumask_t
References: <20080906235036.891970000@polaris-admin.engr.sgi.com> <20080906235037.880702000@polaris-admin.engr.sgi.com> <1220783087.8687.73.camel@twins.programming.kicks-ass.net> <48C53C91.70604@sgi.com> <1220886335.12278.31.camel@twins.programming.kicks-ass.net> <20080908183852.GA3713@elte.hu> <48C84E9E.7080507@sgi.com> <20080910225345.GL7714@one.firstfloor.org>
In-Reply-To: <20080910225345.GL7714@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Here's an initial proposal for abstracting cpumask_t to be either
> 
> At least for some cases I don't think you'll get around defining
> a "nearby subset of CPUs that can be handled together" type. Handling 1K 
> objects all the time in one piece is simply not a good idea.
> 
> -Andi


Every time I stop to think about this, the problems with the cpu
operators come to mind.  Should there be a separate set?  Or simply
conversion functions to/from a "cpumask_subset" type?  

Thanks,
Mike
