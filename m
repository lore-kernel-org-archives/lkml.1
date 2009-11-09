Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbZKIIzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbZKIIzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbZKIIzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:55:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:53942 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbZKIIzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:55:08 -0500
Subject: Re: [patch 09/16] powerpc: Replace old style lock initializer
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20091109161502.ab064092.sfr@canb.auug.org.au>
References: <20091106223547.784916750@linutronix.de>
	 <20091106223806.762624109@linutronix.de>
	 <1257548144.13611.267.camel@pasglop>
	 <20091109161502.ab064092.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 19:53:25 +1100
Message-ID: <1257756805.13611.296.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 16:15 +1100, Stephen Rothwell wrote:
> Hi Thomas,
> 
> On Sat, 07 Nov 2009 09:55:44 +1100 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> >
> > On Fri, 2009-11-06 at 22:41 +0000, Thomas Gleixner wrote:
> > > plain text document attachment
> > > (power-replace-old-style-lock-init.patch)
> > > SPIN_LOCK_UNLOCKED is deprecated. Init the lock array at runtime
> > > instead.
> > > 
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > > Cc: linuxppc-dev@ozlabs.org
> > > ---
> > 
> > Looks reasonable. But iseries can be a bitch, so we do need to test it
> > on monday.
> 
> Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks Stephen !

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

