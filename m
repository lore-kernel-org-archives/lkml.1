Return-Path: <linux-kernel-owner+w=401wt.eu-S933352AbXHXKDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352AbXHXKDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 06:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbXHXKDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 06:03:39 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:39011 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763946AbXHXKDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 06:03:37 -0400
Date: Fri, 24 Aug 2007 19:02:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what is the value of the macro "__setup_param"?
Message-ID: <20070824100217.GA32109@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0708240516080.14019@localhost.localdomain> <20070824095058.GA32013@linux-sh.org> <Pine.LNX.4.64.0708240548220.15507@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708240548220.15507@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 05:49:42AM -0400, Robert P. J. Day wrote:
> On Fri, 24 Aug 2007, Paul Mundt wrote:
> 
> > On Fri, Aug 24, 2007 at 05:19:29AM -0400, Robert P. J. Day wrote:
> > >
> > >   perhaps i'm missing it, but it seems that the macro __setup_param is
> > > entirely superfluous:
> > >
> > > $ grep -rw __setup_param *
> > > include/linux/init.h:#define __setup_param(str, unique_id, fn, early)      \
> > > include/linux/init.h:   __setup_param(str, unique_id, NULL, 0)
> > > include/linux/init.h:   __setup_param(str, fn, fn, 0)
> > > include/linux/init.h:   __setup_param(str, fn, fn, 1)
> > > include/linux/init.h:#define __setup_param(str, unique_id, fn)  /* nothing */
> > > $
> > >
> > > or am i must misreading something badly?
> 
> > Superfluous how? It does different things depending on whether
> > MODULE is defined or not. It's a good indicator of how often people
> > use __setup_param() from module context though, given the complete
> > mismatch of parameters. It's probably worth fixing that up at least.
> 
> never mind, i've already clued in.  up too long, and trying to do too
> many things at once.  more sleep or more coffee -- time to make a
> decision.  sorry for the noise.
> 
That's great, but you've ignored the second part of my mail. I'll
summarize:

> > > include/linux/init.h:#define __setup_param(str, unique_id, fn, early)      \
> > > include/linux/init.h:#define __setup_param(str, unique_id, fn)  /* nothing */

Notice the problem now? :-)
