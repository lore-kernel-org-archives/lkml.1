Return-Path: <linux-kernel-owner+w=401wt.eu-S1765595AbXEVOtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765595AbXEVOtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 10:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbXEVOs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 10:48:56 -0400
Received: from [216.16.235.2] ([216.16.235.2]:52965 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756350AbXEVOsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 10:48:55 -0400
X-Originating-Ip: 72.143.65.211
Date: Tue, 22 May 2007 10:47:45 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
In-Reply-To: <a781481a0705220709s40b80208h47f1f2f7c00a684d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705221045020.14953@localhost.localdomain>
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain> 
 <alpine.DEB.0.99.0705220950160.3308@sigma.j-a-k-j.com> 
 <Pine.LNX.4.64.0705220959310.14408@localhost.localdomain>
 <a781481a0705220709s40b80208h47f1f2f7c00a684d@mail.gmail.com>
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

On Tue, 22 May 2007, Satyam Sharma wrote:

> On 5/22/07, Robert P. J. Day <rpjday@mindspring.com> wrote:

> > actually, one of the folks on the KJ list found this:
> >
> >   http://www.ussg.iu.edu/hypermail/linux/kernel/9605/1957.html
> >
> > which speaks thusly:
> >
> > ...
> > -#if __GNUC__ < 2 || (__GNUC__ == 2 && __GNUC_MINOR__ < 5)
> > -# define NORET_TYPE __volatile__
> > -# define ATTRIB_NORET /**/
> > -# define NORET_AND /**/
> > -#else
> > # define NORET_TYPE /**/
> > # define ATTRIB_NORET __attribute__((noreturn))
> > # define NORET_AND noreturn,
> > -#endif
> > ...
> >
> >   so it looks like a thoroughly obsolete macro which can be tossed.
> > i'll make the patch and test it.
>
> AFAICT, NORET_TYPE must've been introduced to silence gcc
> _warnings_, and not do actually do anything useful that affects
> functionality in any way. So the way to "test" your patch would be
> to see if there is any increase / decrease in the number of
> *warnings* blurted out by gcc during kernel build (best would be to
> build with various gcc versions on various platforms :-)

i can understand that logic but, since that macro wouldn't have any
effect since gcc-2.2.5 and the current version of the kernel won't
even *build* with gcc < 3.2, i can't imagine how there could be any
difference these days.

of course, i've been unpleasantly surprised before.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
