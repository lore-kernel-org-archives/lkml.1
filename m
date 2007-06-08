Return-Path: <linux-kernel-owner+w=401wt.eu-S939312AbXFHPsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939312AbXFHPsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761353AbXFHPsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:48:01 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:44329 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759920AbXFHPsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:48:00 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 8 Jun 2007 11:46:23 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Include <asm/termbits.h> from <linux/tty_driver.h>.
In-Reply-To: <20070608164830.54436f6b@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0706081144300.31863@localhost.localdomain>
References: <Pine.LNX.4.64.0706080925020.24228@localhost.localdomain>
 <20070608163018.636b74d1@the-village.bc.nu> <Pine.LNX.4.64.0706081125390.30491@localhost.localdomain>
 <20070608164830.54436f6b@the-village.bc.nu>
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

> > i don't see how fixing the C file solves this issue.  the header
> > file <linux/tty_driver.h> clearly refers to "struct ktermios", for
> > which it won't have a definition unless it includes
> > <asm/termbits.h>.
>
> Anyone using tty stuff will include <linux/tty.h> to get all the
> stuff needed an that includes asm/termios.h which includes
> asm/termbits.h

that may well be, but i don't think counting on the choice or order of
header file inclusions represents a really robust approach to software
design.

if a header file needs a definition/declaration that exists in another
header file, it should include that other header file.  any other
approach is wrong.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
