Return-Path: <linux-kernel-owner+w=401wt.eu-S1762592AbXHYVuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762592AbXHYVuS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 17:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXHYVuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 17:50:04 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:35425 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbXHYVuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 17:50:03 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 25 Aug 2007 17:40:00 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Al Viro <viro@ftp.linux.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] FS: Make RAMFS both selectable and tristate.
In-Reply-To: <20070825212920.GB21089@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0708251736050.12852@localhost.localdomain>
References: <Pine.LNX.4.64.0708251538320.29214@localhost.localdomain>
 <20070825212920.GB21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2007, Al Viro wrote:

> On Sat, Aug 25, 2007 at 03:40:23PM -0400, Robert P. J. Day wrote:
> >
> > Allow RAMFS to be user-selectable, and to be built as a module.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
> > ---
> >
> >   given that the help content for that option suggests it can be built
> > as a module, it just makes sense to make it selectable and tristate,
> > unless someone has a compelling argument against it.
>
> How about "check if the kernel builds if you do that"?

i did.  i did a simple "make defconfig" and "make", and the kernel
built fine.  that patch didn't change the status of RAMFS in any way,
it was still selected as default "y", so why would that patch have
made any difference to the eventual build?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
