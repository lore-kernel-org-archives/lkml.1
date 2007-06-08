Return-Path: <linux-kernel-owner+w=401wt.eu-S969717AbXFHPgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969717AbXFHPgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968402AbXFHPfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:35:47 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43494 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968478AbXFHPfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:35:46 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 8 Jun 2007 11:34:01 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Include <asm/termbits.h> from <linux/tty_driver.h>.
In-Reply-To: <Pine.LNX.4.64.0706081727110.10769@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0706081131150.30811@localhost.localdomain>
References: <Pine.LNX.4.64.0706080925020.24228@localhost.localdomain>
 <20070608163018.636b74d1@the-village.bc.nu>
 <Pine.LNX.4.64.0706081727110.10769@fbirervta.pbzchgretzou.qr>
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

On Fri, 8 Jun 2007, Jan Engelhardt wrote:

>
> On Jun 8 2007 16:30, Alan Cox wrote:
> >
> >>
> >> The header file <linux/tty_driver.h> should include <asm/termbits.h>
> >> to pick up the definition of "struct ktermios"; otherwise, you run the
> >> risk of seeing:
> >
> >Risk - which compile combinations does it actually show up with and
> >is it not better to fix the C file in question not grow the
> >horribly tangled include deps further
>
> struct ktermios; /* that's it */

um ... what does that mean?  consider this snippet from
<linux/tty_driver.h>:

struct tty_driver {
	...
        struct ktermios init_termios; /* Initial termios */
	...

  doesn't this suggest that you better have a definition of that
ktermios struct before this point?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
