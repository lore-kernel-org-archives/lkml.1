Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbXFWMK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbXFWMK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 08:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXFWMKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 08:10:14 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:34654 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbXFWMKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 08:10:13 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 23 Jun 2007 08:06:37 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Arnd Bergmann <arnd@arndb.de>
cc: Florin Iucha <florin@iucha.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "upping" a semaphore from interrupt context?
In-Reply-To: <200706231402.03617.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.0706230804060.4666@localhost.localdomain>
References: <20070622173839.GB8398@iucha.net> <200706221934.18436.arnd@arndb.de>
 <Pine.LNX.4.64.0706230751230.4164@localhost.localdomain> <200706231402.03617.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1089496215-1182600397=:4666"
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

--8323328-1089496215-1182600397=:4666
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sat, 23 Jun 2007, Arnd Bergmann wrote:

> On Saturday 23 June 2007, Robert P. J. Day wrote:
> > On Fri, 22 Jun 2007, Arnd Bergmann wrote:
> > >
> > > yes, but you should not. The use of semaphores is not
> > > recommended for new code, it should be replaced with either a
> > > mutex or a completion.
> >
> > can you clarify this?  it sounds like you're saying that the
> > current implementation of semaphores is entirely superfluous.  but
> > surely it isn't possible to replace all semaphores with either
> > mutexes or completions, is it?
>
> No, not all of them, but the vast majority. There are multiple
> differences, the most important one being the 'counting' in
> semaphores.

right, that was exactly the feature i was thinking of.  ok, i'm clear
on this now -- while the *majority* of semaphores can be more properly
replaced by mutexes or completions, there will always be a need for a
general-purpose counting semaphore.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
--8323328-1089496215-1182600397=:4666--
