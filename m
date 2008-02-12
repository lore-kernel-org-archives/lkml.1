Return-Path: <linux-kernel-owner+w=401wt.eu-S1763367AbYBLQ0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763367AbYBLQ0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763276AbYBLQ01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:26:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53346 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763266AbYBLQ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:26:26 -0500
Date: Tue, 12 Feb 2008 18:01:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212170155.GA4191@one.firstfloor.org>
References: <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <20080212161152.GA3281@one.firstfloor.org> <20080212162408.GB17947@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212162408.GB17947@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 05:24:08PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Anyways the slight risk of the other CPUs eventually recovering would 
> > seem a acceptable trade off versus not being able to use the debugger 
> > to debug the system with hanging CPUs.
> 
> see? There's the difference between us. The initial merge of KGDB does 
> not want to include policies for nuances that pose an "acceptable slight 
> risk".

Ok fine. Please implement DMA quiescence on kgdb entry then; otherwise
the code won't conform to your standards at all.

-Andi
