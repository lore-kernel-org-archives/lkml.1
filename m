Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbXETO4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbXETO4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 10:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbXETO4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 10:56:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:47262 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756541AbXETO4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 10:56:40 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX1+dd+IlPRqdEzLEt+JGawteE+5O14D0yO7T8Y9Fni
	q4ZT+pGZTx+Lhs
From: Uwe Bugla <uwe.bugla@gmx.de>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Date: Sun, 20 May 2007 16:52:00 +0200
User-Agent: KMail/1.9.5
References: <464F42F3.1080300@madrabbit.org> <20070520062816.GA4095@ftp.linux.org.uk> <200705201058.38117.arvidjaar@mail.ru>
In-Reply-To: <200705201058.38117.arvidjaar@mail.ru>
Cc: Ray Lee <ray-lk@madrabbit.org>, Uwe Bugla <uwe.bugla@gmx.de>,
       Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705201652.00503.uwe.bugla@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 20. Mai 2007 08:58 schrieben Sie:
> On Sunday 20 May 2007, Al Viro wrote:
> > On Sat, May 19, 2007 at 11:16:59PM -0700, Ray Lee wrote:
> > > Ken? Ball's in your court. As the patch isn't providing a killer
> > > feature for 2.6.22, I'd suggest just reverting it for now until the
> > > issues are ironed out.
> >
> > Hold it.  The real question here is which logics do we want there.
> > IOW, and how many device nodes do we want to appear and _when_ do
> > we want them to appear?
>
> of course we'd like to use exactly as many (or few) nodes as are in use
> right now and without fixed limit for their number; which implies that
> nodes should appear and go on as needed basis.
>
> But right now there is no kernel mechanism that user level program could
> use to request allocation of new loop node. I won't discuss whether it is
> legitimate to mandate new version of util-linux for kernel 2.6.22; but it
> is obvious that any kernel patch that adds such mechanism goes far beyond
> simple bug fix and is not acceptable at this stage.
>
> So let's revert this change and discuss it for post-2.6.22 timeframe.

Hi,

I am of course not a fan of limiting the maximum of available loops to 8.

My question / proposal for now would be:

Could anybody of you please be kind enough and write / provide me a counter 
patch supplying me:

a. a compilable 2.6.22-rc2 kernel
b. a loop device that can mount up to 8 iso-images

I would prefer this thing as outline attachment due to Email client 
wordwrapping problems.

Looking happily forward to a functionable counter patch to resolve the current 
issue as a compromise solution,

Best regards and thanks

Uwe
