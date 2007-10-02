Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbXJBHqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbXJBHqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbXJBHqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:46:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33647 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbXJBHqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:46:36 -0400
Date: Tue, 2 Oct 2007 09:46:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, "Huang, Ying" <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: x86 patches was Re: -mm merge plans for 2.6.24
Message-ID: <20071002074635.GA31066@one.firstfloor.org>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <p733awu6nva.fsf@bingen.suse.de> <20071001233225.88c67e8b.akpm@linux-foundation.org> <20071002073703.GA31108@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002073703.GA31108@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 09:37:03AM +0200, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On 02 Oct 2007 08:18:17 +0200 Andi Kleen <andi@firstfloor.org> wrote:
> >
> > > The clockevents patches are not included in this; but given the 
> > > recent trouble i'm not 100% sure they are even ready yet.
> 
> i'm curious, which "recent trouble" do you refer to? (The NMI watchdog 
> bug [which is off by default] was fixed quickly. The C1E bug was found 
> and fixed quickly. Anything else i missed?)

C1e and now the misrouted irq 0s Thomas reported.

Also i'm a little worried about the missing C1e check; it looks
like it needs a re-review to make sure not other infrastructure was 
missing.

> 
> > hm, well, I hope you and Thomas are on the same page regarding 
> > precisely what the remaining issues are.
> 
> i'd like to see the 64-bit clockevents (& dynticks) patches merged. 
> Demand from users and distros is high.

I'm aware of that. No argument on that it will eventually go in.

-Andi
