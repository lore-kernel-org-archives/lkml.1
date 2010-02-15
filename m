Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab0BOUAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:00:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:59944 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350Ab0BOUAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:00:11 -0500
Subject: Re: register long sp asm("r1") incorrect
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20100215073405.GB20456@atrey.karlin.mff.cuni.cz>
References: <20100209152444.GA30176@atrey.karlin.mff.cuni.cz>
	 <1265866273.16346.34.camel@pasglop>
	 <20100215073405.GB20456@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Feb 2010 06:59:52 +1100
Message-ID: <1266263992.16346.125.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-15 at 08:34 +0100, Pavel Machek wrote:
> > On Tue, 2010-02-09 at 16:24 +0100, Pavel Machek wrote:
> > > ...according to gcc docs, sp should be global, or placement in
> > > register is not guaranteed (except at asm boundaries, but there
> are
> > > none).
> > 
> > Sorry I'm not sure I grok what you mean.
> 
> Well, according to gcc doscs and my experience, local "register int
> __asm()" variables only work by accident (or not at all). 

Hrm... we definitely rely on that for our thread_info() access, and so
far it has worked well for us, but I'll poke our gcc folks just in case.

Cheers,
Ben.


