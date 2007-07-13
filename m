Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbXGMKBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbXGMKBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 06:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbXGMKBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 06:01:06 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:47264 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbXGMKBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 06:01:04 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 13 Jul 2007 05:58:30 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Christoph Hellwig <hch@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Make asm-generic/ioctl.h more generic using conditionals.
In-Reply-To: <20070713095620.GD16304@infradead.org>
Message-ID: <Pine.LNX.4.64.0707130557070.6531@localhost.localdomain>
References: <Pine.LNX.4.64.0707100629070.11966@localhost.localdomain>
 <20070713095620.GD16304@infradead.org>
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

On Fri, 13 Jul 2007, Christoph Hellwig wrote:

> On Tue, Jul 10, 2007 at 06:33:26AM -0400, Robert P. J. Day wrote:
> > + * Let any architecture override either of the following before
> > + * including this file.
> > + */
> > +
> > +#ifndef _IOC_SIZEBITS
> > +# define _IOC_SIZEBITS	14
> > +#endif
> > +
> > +#ifndef _IOC_DIRBITS
> > +# define _IOC_DIRBITS	2
> > +#endif
>
> I don't think this is usefull.  It just makes it less obvious to
> find this definition which must not change ever due to abi reasons
> anyway.

huh?

alpha:

 #define _IOC_SIZEBITS  13
 #define _IOC_DIRBITS   3

mips:

 #define _IOC_SIZEBITS  13
 #define _IOC_DIRBITS   3

powerpc:

 #define _IOC_SIZEBITS  13
 #define _IOC_DIRBITS   3

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
