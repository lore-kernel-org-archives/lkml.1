Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYG3SrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYG3SrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYG3Sqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:46:53 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:54788 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbYG3Sqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:46:52 -0400
Date: Wed, 30 Jul 2008 20:47:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Dike <jdike@addtoit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] x86: use arch/x86/include
Message-ID: <20080730184700.GA29710@uranus.ravnborg.org>
References: <20080730124952.GA23413@uranus.ravnborg.org> <20080730180411.GA7896@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730180411.GA7896@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 08:04:11PM +0200, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > Hi x86 guys.
> > 
> > It turned out to be easy to enable um to use arch/x86/include so here 
> > is a git pull.
> 
> hm, we have a _ton_ of changes to include files queued up already, so 
> this is rather inconvenient.
git should cope with this if changes come in via git. I do not
know about "git am" applied patches.

> 
> I missed the discussion on this, what's the point of renaming all these 
> files?

It has been discussed many times to keep arch and arch include files
under arch/.
Lately Linus outlined this:

    http://kerneltrap.org/mailarchive/linux-kernel/2008/5/21/1903924

I took the ball and did the kbuild side of this so we could do this
gradually.
sparc are already converted. sh has it ready to be pulled and others
are playing with it.

How we do it in the best way for such a fragile codebase as x86 is
I am not sure. I would assume to do it late in the merge window where
the minimum set of patches are queued up would be best (and this is now).

And Linus already said he would like to take it sooner.
Quote:

====================================================================
On Tue, 29 Jul 2008, Sam Ravnborg wrote:
>
> But will you accept this stuff now or will we have to wait until
> next merge window?

if the patches are really small adn the resulting build is well tested
(ignoring the actual _move_ operation), I'm ok with taking them.

In fact, in many ways I'd _prefer_ to do it now, rather than have it
pending and then do it durign the next merge window when there are a lot
of non-movement changes too.
====================================================================

	Sam
