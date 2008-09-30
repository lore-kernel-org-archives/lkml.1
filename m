Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbYI3DVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbYI3DVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYI3DTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:19:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:60947 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYI3DTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:19:37 -0400
Date: Mon, 29 Sep 2008 20:19:45 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: Linux 2.6.27-rc8
Message-ID: <20080929201945.26327311@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0809291909360.3389@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
	<Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz>
	<alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org>
	<21d7e9970809291859s5bff81e3ue0f63402c2ad422d@mail.gmail.com>
	<alpine.LFD.2.00.0809291909360.3389@nehalem.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008 19:21:02 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 30 Sep 2008, Dave Airlie wrote:
> > 
> > If it is X related then its both a kernel + X server issue, the
> > e1000e driver opens the barn door, the X server drives the horses
> > through it.
> 
> Are you sure? There was a mandriva report abou NVM corruption on an
> e100 too (that one apparently just caused PXE failure, the networking
> worked fine).
> 
> So I wonder if it's _purely_ X-server-related, adn the reason people
> blame 2.6.27-rc1 is just timing of some X update and then people just
> look at the kernel beceuse the 'network card failed' looks so
> kernel-related.
> 
> The reason I mention that is right now it looks like the distros are
> just running around disabling the e1000e module, or perhaps
> downgrading it. Which may not even work!


btw, we're also working on making some parts of the kernel more robust
against certain types of bugs; for example the ioremap checks and sysfs
resource checks. There's a set of checks and API changes we can do to
make it less likely that drivers end up doing bad stuff; but that's
obviously more for 2.6.28 than for .27



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
