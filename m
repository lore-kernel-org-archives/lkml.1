Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997Ab0AMQ1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab0AMQ1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862Ab0AMQ1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:27:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab0AMQ1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:27:51 -0500
Date: Wed, 13 Jan 2010 11:25:34 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>,
       aris@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: introduce NMI_AUTO as nmi_watchdog option
Message-ID: <20100113162534.GX24885@redhat.com>
References: <20100111191633.GT24885@redhat.com>
 <20100111202729.GI4923@lenovo>
 <20100111203356.GU24885@redhat.com>
 <20100113093240.GC6739@elte.hu>
 <1263388422.4244.214.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263388422.4244.214.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 02:13:42PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-01-13 at 10:32 +0100, Ingo Molnar wrote:
> > other architectures have NMI concepts as well, such as Sparc64. 
> 
> I think both sparc64 and ppc64 fake NMIs by playing games with hw IRQ
> priorities and partial masks. But yes.
> 
> One interesting 'feature' for the perf-nmi interaction is creating an
> idle scheduling class for counters, because as long as there is a
> counter present you can use his NMIs to drive the watchdog, but as soon
> as there are non left, you need to install one.

Interesting idea.  How can I guarantee the frequency of the NMI I want to
piggyback off of?  A breakpoint that takes an hour to trigger may not be
the best NMI to use?  Then again I am still trying to understand the perf
event code a little better.

Cheers,
Don
