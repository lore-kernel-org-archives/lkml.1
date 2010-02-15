Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab0BOU3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:29:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47626 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab0BOU3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:29:08 -0500
Date: Mon, 15 Feb 2010 21:28:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: register long sp asm("r1") incorrect
Message-ID: <20100215202854.GA21601@elf.ucw.cz>
References: <20100209152444.GA30176@atrey.karlin.mff.cuni.cz>
 <1265866273.16346.34.camel@pasglop>
 <20100215073405.GB20456@atrey.karlin.mff.cuni.cz>
 <1266263992.16346.125.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266263992.16346.125.camel@pasglop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-02-16 06:59:52, Benjamin Herrenschmidt wrote:
> On Mon, 2010-02-15 at 08:34 +0100, Pavel Machek wrote:
> > > On Tue, 2010-02-09 at 16:24 +0100, Pavel Machek wrote:
> > > > ...according to gcc docs, sp should be global, or placement in
> > > > register is not guaranteed (except at asm boundaries, but there
> > are
> > > > none).
> > > 
> > > Sorry I'm not sure I grok what you mean.
> > 
> > Well, according to gcc doscs and my experience, local "register int
> > __asm()" variables only work by accident (or not at all). 
> 
> Hrm... we definitely rely on that for our thread_info() access, and so
> far it has worked well for us, but I'll poke our gcc folks just in case.

Thanks, and let me know about any results.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
