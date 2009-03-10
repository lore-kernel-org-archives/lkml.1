Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbZCJK3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbZCJK3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 06:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbZCJK3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 06:29:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42502 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbZCJK3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 06:29:38 -0400
Subject: Re: [announce] Performance Counters for Linux, v6
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <20090310094457.GU10085@erda.amd.com>
References: <20090121185021.GA8852@elte.hu>
	 <20090309013902.GK10085@erda.amd.com>
	 <18869.40904.382716.827097@cargo.ozlabs.ibm.com>
	 <20090310094457.GU10085@erda.amd.com>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 11:29:12 +0100
Message-Id: <1236680952.25234.81.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 10:44 +0100, Robert Richter wrote:
> I agree, it is much more easier to change the in-kernel i/f. I just
> wanted to emphasize the importance of this i/f. Oprofile, Perfmon and
> also LPC will exist in the future too and should share the same code
> base. That's what I missed in the discussion until now.

We could implement oprofile on top of lpc for those archs that have LPC
support. And afaik only ia64 needs to bother with perfmon as that's the
only arch that has support for it anyway.

Now, even on x86 LPC would need a little more arch support before we can
fully replace oprofile, but a half-way model would be a LPC oprofile
driver that uses LPC on those machines its supported on, while working
to provide LPC support for the older machines.



