Return-Path: <linux-kernel-owner+w=401wt.eu-S1764103AbZCaW5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764103AbZCaW5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932122AbZCaW5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:57:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42423
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932112AbZCaW5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:57:20 -0400
Date: Tue, 31 Mar 2009 15:57:08 -0700 (PDT)
Message-Id: <20090331.155708.124308722.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: mingo@elte.hu, tj@kernel.org, schwidefsky@de.ibm.com, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       lethal@linux-sh.org, rmk@arm.linux.org.uk, starvik@axis.com,
       ralf@linux-mips.org, cooloney@kernel.org, kyle@mcmartin.ca,
       matthew@wil.cx, grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org,
       npiggin@suse.de, cl@linux-foundation.org
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
 default percpu allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <200903311204.51774.rusty@rustcorp.com.au>
References: <49D099F0.3000807@kernel.org>
	<20090330114938.GB10070@elte.hu>
	<200903311204.51774.rusty@rustcorp.com.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Tue, 31 Mar 2009 12:04:50 +1030

> On Monday 30 March 2009 22:19:38 Ingo Molnar wrote:
> > 
> > * Tejun Heo <tj@kernel.org> wrote:
> ...
> > We also need the Ack from Davem for Sparc32, the Ack from Martin, an 
> > Ack from Ben for the PowerPC bits and an ack from Tony for the IA64 
> > bits. We also need the ack from Andrew and Rusty for the MM and 
> > module bits.
> 
> Module bits are trivial, but Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> just in case :)

I'm fine with the sparc32 bits:

Acked-by: David S. Miller <davem@davemloft.net>

And I'll work on sparc64 support.
