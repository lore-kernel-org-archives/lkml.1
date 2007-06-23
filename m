Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbXFWQQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbXFWQQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 12:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbXFWQQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 12:16:26 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:46566 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbXFWQQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 12:16:26 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 23 Jun 2007 12:11:57 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Arnd Bergmann <arnd@arndb.de>, Florin Iucha <florin@iucha.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "upping" a semaphore from interrupt context?
In-Reply-To: <a781481a0706230842l141cf400tb2f5645b6b6537fe@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706231209490.15371@localhost.localdomain>
References: <20070622173839.GB8398@iucha.net>  <200706221934.18436.arnd@arndb.de>
  <Pine.LNX.4.64.0706230751230.4164@localhost.localdomain> 
 <200706231402.03617.arnd@arndb.de> <a781481a0706230842l141cf400tb2f5645b6b6537fe@mail.gmail.com>
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

On Sat, 23 Jun 2007, Satyam Sharma wrote:

> Hi Robert, Arnd,
>
> On 6/23/07, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Saturday 23 June 2007, Robert P. J. Day wrote:
> > > On Fri, 22 Jun 2007, Arnd Bergmann wrote:
> > > >
> > > > yes, but you should not. The use of semaphores is not recommended
> > > > for new code, it should be replaced with either a mutex or a
> > > > completion.
> > >
> > > can you clarify this? it sounds like you're saying that the current
> > > implementation of semaphores is entirely superfluous. but surely it
> > > isn't possible to replace all semaphores with either mutexes or
> > > completions, is it?
>
> Semaphores being used as completions are superfluous, obsoleted by
> completion handlers. Semaphores that are not counted (hence binary)
> are superfluous, obsoleted by struct mutex.

hang on, how is that true?  as i read it, mutexes are more than just
binary semaphores -- they have additional restrictions that regular
semaphores don't.  so i'm not convinced that binary semaphores can
simply be replaced by mutexes, unless that's not what you meant here.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
