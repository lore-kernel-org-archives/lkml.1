Return-Path: <linux-kernel-owner+w=401wt.eu-S1763005AbXFECei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763005AbXFECei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 22:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758413AbXFECeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 22:34:31 -0400
Received: from waste.org ([66.93.16.53]:56312 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757767AbXFECeb (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 22:34:31 -0400
Date: Mon, 4 Jun 2007 21:34:12 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070605023412.GN11115@waste.org>
References: <20070604173710.GR11166@waste.org> <1181002734.25878.56.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181002734.25878.56.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 10:18:54AM +1000, Rusty Russell wrote:
> On Mon, 2007-06-04 at 12:37 -0500, Matt Mackall wrote:
> > With 2.6.22-rc3-mm1, I've got a long-running video transcoding going
> > on. In other windows, I'm compiling, reading email, etc. with no
> > noticeable problems.
> > 
> > If I fire up lguest and leave it sitting at a shell prompt for a
> > couple moments, when I return to type something at the prompt, it can
> > take 2-3 seconds for my input to echo. Once it starts responding,
> > typing latency disappears. Suspend the other app and the latency
> > disappears.
> 
> This sounds like the waker process (nice 19) not getting a chance to
> run.  You can hack around it for the moment by changing "nice(19)" in
> Documentation/lguest/lguest.c to something less aggressive.

Manual renicing seems to have done the trick.

This is still a little suspicious though. Why does it take two seconds
to wake up and then behave responsively for a long interval after that?

-- 
Mathematics is the supreme nostalgia of our time.
