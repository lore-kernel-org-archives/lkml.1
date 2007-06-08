Return-Path: <linux-kernel-owner+w=401wt.eu-S969911AbXFHPoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969911AbXFHPoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966229AbXFHPnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:43:53 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:44048 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762996AbXFHPnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:43:51 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 8 Jun 2007 11:42:10 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Include <asm/termbits.h> from <linux/tty_driver.h>.
In-Reply-To: <20070608164533.1ed24e79@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0706081139310.31532@localhost.localdomain>
References: <Pine.LNX.4.64.0706080925020.24228@localhost.localdomain>
 <20070608163018.636b74d1@the-village.bc.nu>
 <Pine.LNX.4.64.0706081727110.10769@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0706081131150.30811@localhost.localdomain>
 <20070608164533.1ed24e79@the-village.bc.nu>
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

On Fri, 8 Jun 2007, Alan Cox wrote:

> > > >Risk - which compile combinations does it actually show up with and
> > > >is it not better to fix the C file in question not grow the
> > > >horribly tangled include deps further
> > >
> > > struct ktermios; /* that's it */
> >
> > um ... what does that mean?  consider this snippet from
> > <linux/tty_driver.h>:
>
> Which compile combination shows the sequence you are reporting ?

sorry, i don't understand the question.  i'm just running "make" on a
simple module i wrote, using the prototypical in-directory makefile to
build out-of-tree.

the first four lines of my module source file are:

#include <linux/module.h>
#include <linux/init.h>
#include <asm/termbits.h>               /* Shouldn't be necessary */
#include <linux/tty_driver.h>           /* For struct tty_driver */

  if i omit the inclusion of the termbits.h header, i get the
aforementioned error.  beyond that, i'm unclear on what you're asking.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
