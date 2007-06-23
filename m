Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbXFWL5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbXFWL5X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 07:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbXFWL5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 07:57:16 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:33939 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbXFWL5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 07:57:15 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 23 Jun 2007 07:52:51 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Arnd Bergmann <arnd@arndb.de>
cc: Florin Iucha <florin@iucha.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "upping" a semaphore from interrupt context?
In-Reply-To: <200706221934.18436.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.0706230751230.4164@localhost.localdomain>
References: <20070622173839.GB8398@iucha.net> <200706221934.18436.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-343429529-1182599571=:4164"
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-343429529-1182599571=:4164
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 22 Jun 2007, Arnd Bergmann wrote:

> On Friday 22 June 2007, Florin Iucha wrote:
> > I am writing a USB driver for some custom hardware, and I need to
> > synchronize between the user-space and the USB subsystem.  Can I
> > create a semaphore and "down" it in the reader then "up" it in the
> > completion handler?
>
> yes, but you should not. The use of semaphores is not recommended
> for new code, it should be replaced with either a mutex or a
> completion.

can you clarify this?  it sounds like you're saying that the current
implementation of semaphores is entirely superfluous.  but surely it
isn't possible to replace all semaphores with either mutexes or
completions, is it?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
--8323328-343429529-1182599571=:4164--
