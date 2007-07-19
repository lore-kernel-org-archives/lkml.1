Return-Path: <linux-kernel-owner+w=401wt.eu-S1762214AbXGSW6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214AbXGSW6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 18:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbXGSW6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 18:58:30 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:45089 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbXGSW6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 18:58:30 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 19 Jul 2007 18:56:34 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jirislaby@gmail.com
Subject: Re: [PATCH] Warn userspace about including an empty linux/tty.h.
In-Reply-To: <20070719152035.1cb98525.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707191855410.7525@localhost.localdomain>
References: <Pine.LNX.4.64.0707190721520.25369@localhost.localdomain>
 <20070719152035.1cb98525.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Andrew Morton wrote:

> On Thu, 19 Jul 2007 07:23:46 -0400 (EDT)
> "Robert P. J. Day" <rpjday@mindspring.com> wrote:
>
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
> > ---
> >
> >   what subsystem would something like this belong to?
> >
> >
> > diff --git a/include/linux/tty.h b/include/linux/tty.h
> > index 691a174..fd67da8 100644
> > --- a/include/linux/tty.h
> > +++ b/include/linux/tty.h
> > @@ -5,6 +5,10 @@
> >   * 'tty.h' defines some structures used by tty_io.c and some defines.
> >   */
> >
> > +#ifndef __KERNEL__
> > +#warning "Please don't include this file from userspace, it's empty."
> > +#endif
> > +
>
> this seems pointless?

it was one of the suggestions that was made.  the other was just to
stop exporting tty.h to userspace entirely, but that might break
something in userspace.  i really had no strong opinion either way.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
