Return-Path: <linux-kernel-owner+w=401wt.eu-S938837AbXFHPbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938837AbXFHPbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932768AbXFHPbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:31:37 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43249 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763697AbXFHPbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:31:36 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 8 Jun 2007 11:29:57 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Include <asm/termbits.h> from <linux/tty_driver.h>.
In-Reply-To: <20070608163018.636b74d1@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0706081125390.30491@localhost.localdomain>
References: <Pine.LNX.4.64.0706080925020.24228@localhost.localdomain>
 <20070608163018.636b74d1@the-village.bc.nu>
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

> On Fri, 8 Jun 2007 09:29:12 -0400 (EDT)
> "Robert P. J. Day" <rpjday@mindspring.com> wrote:
>
> > The header file <linux/tty_driver.h> should include
> > <asm/termbits.h> to pick up the definition of "struct ktermios";
> > otherwise, you run the risk of seeing:
>
> Risk - which compile combinations does it actually show up with and
> is it not better to fix the C file in question not grow the horribly
> tangled include deps further

i don't see how fixing the C file solves this issue.  the header file
<linux/tty_driver.h> clearly refers to "struct ktermios", for which it
won't have a definition unless it includes <asm/termbits.h>.

you can hack a solution by explicitly including the latter first, of
course, but i don't see how that constitutes a proper fix.  or am i
misreading something here?

rday

p.s.  this isn't just theoretical -- this bit me this morning as i was
writing a simple module to flash the keyboard LEDs, just for the
entertainment value.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
