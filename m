Return-Path: <linux-kernel-owner+w=401wt.eu-S933252AbXAaNzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252AbXAaNzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 08:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933231AbXAaNzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 08:55:51 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:34211 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252AbXAaNzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 08:55:50 -0500
X-Originating-Ip: 74.109.98.130
Date: Wed, 31 Jan 2007 08:54:37 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       dhowells@redhat.com, rth@twiddle.net
Subject: Re: [PATCH] Centralize the selection for debugging semaphores.
In-Reply-To: <6bffcb0e0701310544w474810cfh83fbfa539e1c0573@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0701310852460.4816@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0701310825500.4627@CPE00045a9c397f-CM001225dbafb6>
 <6bffcb0e0701310544w474810cfh83fbfa539e1c0573@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007, Michal Piotrowski wrote:

> On 31/01/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> >
> >   Centralize the kernel config option for debugging semaphores and
> > modify the macro for frv to use that config option instead.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> [..]
> > +config DEBUG_SEMAPHORE
> > +       bool "Semaphore debugging"
> > +       depends on DEBUG_KERNEL
> > +       default n
> > +       help
> > +         If you say Y here then semaphore processing will issue lots of
> > +         verbose debugging messages.  If you suspect a semaphore problem or
> > a
> > +         kernel hacker asks for this option then say Y.  Otherwise say N.
> > +
> > +         At the moment, this is implemented only by alpha and frv.
>
> IMHO this option should stay in arch/{alpha,frv}/Kconfig.debug

any particular reason?  and note that it's currently *not* in
arch/frv/Kconfig.debug -- it's hard-coded with a macro name that's not
the same as the config option, and i don't really see the advantage of
having each architecture implement precisely the same feature in
different and incompatible ways.  but i'm willing to be convinced
otherwise.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
