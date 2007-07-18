Return-Path: <linux-kernel-owner+w=401wt.eu-S1762974AbXGRUfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762974AbXGRUfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759012AbXGRUfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:35:24 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:50828 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758346AbXGRUfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:35:22 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 18 Jul 2007 16:33:12 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jiri Slaby <jirislaby@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][RFC] Delete export of tty.h to userspace.
In-Reply-To: <469E7599.4060608@gmail.com>
Message-ID: <Pine.LNX.4.64.0707181631340.14452@localhost.localdomain>
References: <Pine.LNX.4.64.0707180520040.19434@localhost.localdomain>
 <469E7599.4060608@gmail.com>
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

On Wed, 18 Jul 2007, Jiri Slaby wrote:

> Robert P. J. Day napsal(a):
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
> > ---
> >
> >   given that the entire contents of include/linux/tty.h is contained
> > within an "#ifdef __KERNEL__", it seems pointless to export it to
> > userspace, unless there's some kind of need for that header file to
> > exist in userspace, even if it's empty.
> >
> >   a quick grep shows that nothing under /usr/include references any
> > file of the name "tty.h" in any way.  thoughts?
>
> If we decide to remove the file, I would rather go through
> deprecation of the file with filing an entry in
> feature-remove-schedule. There still seems to be some users of the
> file.

i'm curious -- how did you determine that?

> With deprecation done with sth. like
> #ifndef __KERNEL__
> #warning Don't include this file from userspace, it's emtpy.
> #endif

yes, that makes sense.  i can do that.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
