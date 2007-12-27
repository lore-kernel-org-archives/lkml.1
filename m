Return-Path: <linux-kernel-owner+w=401wt.eu-S1752509AbXL0AIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbXL0AIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 19:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbXL0AIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 19:08:43 -0500
Received: from ozlabs.org ([203.10.76.45]:34979 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbXL0AIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 19:08:43 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 02/16] adapt lguest launcher to per-cpuness
Date: Thu, 27 Dec 2007 11:08:24 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>, lguest@ozlabs.org,
       glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org
References: <11981576363806-git-send-email-gcosta@redhat.com> <200712261035.46939.rusty@rustcorp.com.au> <Pine.LNX.4.58.0712260915090.28862@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0712260915090.28862@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712271108.25173.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 December 2007 01:24:10 Steven Rostedt wrote:
> On Wed, 26 Dec 2007, Rusty Russell wrote:
> > On Friday 21 December 2007 00:33:42 Glauber de Oliveira Costa wrote:
> > > +		if (!vcpu_id) {
> > > +			/*
> > > +			 * Service input, then unset the BREAK to
> > > +			 * release the Waker.
> > > +			 */
> > > +			handle_input(lguest_fd);
> > > +			if (pwrite(lguest_fd, args, sizeof(args), 0) < 0)
> > > +				err(1, "Resetting break");
> > > +		}
> >
> > I hate winged comments: those two extra lines, wasted!
>
> For multiple lines, wings are a Good Thing (TM). Otherwise it looks
> sloppy.
>
>   /* Service input, then unset the BREAK to
>    * release the Waker. */
>
> extra asterisk! ok then

No, that is correct.  See all the rest of the lguest comments, or ask Dave 
Miller :)

Of course, if you can keep a comment concisely in one line, it's even better.  
But since colorizing editors are so common, the extra wings just steal 
vertical space.

> Some one buy Rusty a bigger hard-drive to store those extra lines.

More importantly, a bigger screen to hold the code :)

Cheers,
Rusty.
