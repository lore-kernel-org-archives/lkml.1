Return-Path: <linux-kernel-owner+w=401wt.eu-S933634AbXHXKLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634AbXHXKLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 06:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761936AbXHXKL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 06:11:28 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:59373 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760196AbXHXKL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 06:11:27 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 24 Aug 2007 06:01:55 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Paul Mundt <lethal@linux-sh.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what is the value of the macro "__setup_param"?
In-Reply-To: <20070824100217.GA32109@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0708240559450.16247@localhost.localdomain>
References: <Pine.LNX.4.64.0708240516080.14019@localhost.localdomain>
 <20070824095058.GA32013@linux-sh.org> <Pine.LNX.4.64.0708240548220.15507@localhost.localdomain>
 <20070824100217.GA32109@linux-sh.org>
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

On Fri, 24 Aug 2007, Paul Mundt wrote:

> On Fri, Aug 24, 2007 at 05:49:42AM -0400, Robert P. J. Day wrote:
> > On Fri, 24 Aug 2007, Paul Mundt wrote:
> >
> > > On Fri, Aug 24, 2007 at 05:19:29AM -0400, Robert P. J. Day wrote:
> > > >
> > > >   perhaps i'm missing it, but it seems that the macro __setup_param is
> > > > entirely superfluous:
> > > >
> > > > $ grep -rw __setup_param *
> > > > include/linux/init.h:#define __setup_param(str, unique_id, fn, early)      \
> > > > include/linux/init.h:   __setup_param(str, unique_id, NULL, 0)
> > > > include/linux/init.h:   __setup_param(str, fn, fn, 0)
> > > > include/linux/init.h:   __setup_param(str, fn, fn, 1)
> > > > include/linux/init.h:#define __setup_param(str, unique_id, fn)  /* nothing */
> > > > $
> > > >
> > > > or am i must misreading something badly?
> >
> > > Superfluous how? It does different things depending on whether
> > > MODULE is defined or not. It's a good indicator of how often people
> > > use __setup_param() from module context though, given the complete
> > > mismatch of parameters. It's probably worth fixing that up at least.
> >
> > never mind, i've already clued in.  up too long, and trying to do too
> > many things at once.  more sleep or more coffee -- time to make a
> > decision.  sorry for the noise.
> >
> That's great, but you've ignored the second part of my mail. I'll
> summarize:
>
> > > > include/linux/init.h:#define __setup_param(str, unique_id, fn, early)      \
> > > > include/linux/init.h:#define __setup_param(str, unique_id, fn)  /* nothing */
>
> Notice the problem now? :-)

oh, certainly.  i'm just thinking that, in my condition, i shouldn't
be allowed to submit patches or operate heavy machinery at the moment.
:-)

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
