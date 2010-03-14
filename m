Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567Ab0CNSiR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 14:38:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:49133 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758771Ab0CNSiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 14:38:15 -0400
Date: Sun, 14 Mar 2010 11:38:29 -0700
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Larry Finger <Larry.Finger@lwfinger.net>,
       WANG Cong <xiyou.wangcong@gmail.com>, Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] base firmware: Fix BUG from sysfs attributes change in
	commit a2db6842873c8e5a70652f278d469128cb52db70
Message-ID: <20100314183829.GA29048@suse.de>
References: <4b9be956.x5+yAHXGDfXer810%Larry.Finger@lwfinger.net> <alpine.LFD.2.00.1003131426480.3719@i5.linux-foundation.org> <alpine.LRH.2.00.1003132336380.12517@twin.jikos.cz> <alpine.LFD.2.00.1003131455420.3719@i5.linux-foundation.org> <m1fx43zhbd.fsf@fess.ebiederm.org> <alpine.LFD.2.00.1003132131470.3719@i5.linux-foundation.org> <20100314181131.GC28359@suse.de> <m11vfmzrfr.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11vfmzrfr.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 11:30:48AM -0700, Eric W. Biederman wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > On Sat, Mar 13, 2010 at 09:46:46PM -0800, Linus Torvalds wrote:
> >> 
> >> 
> >> On Sat, 13 Mar 2010, Eric W. Biederman wrote:
> >> > 
> >> > It also only affects those fairly rare lockdep users as well, and the only
> >> > affect is to throw a nasty warning message.  Isn't lockdep all about throwing
> >> > nasty warning messages?
> >> 
> >> Hmm. The report has that "BUG: " message in it (and in the subject line), 
> >> but you're right - it ends up being just a warning, not actually a real 
> >> BUG() (which is a machine killer).
> >> 
> >> So yeah - it's not as bad as I thought. Sorry.
> >
> > It's a messy warning, I have patches that should fix the remaining ones
> > that I will send to you tomorrow.
> 
> Greg if you have it that is great.  I started looking through the emails
> I received and it looks like you weren't copied on all of them.  At this
> point I will double check after you send out your changes to Linus.  That
> we have everything I have seen reported.

Why not just forward them all to me, that way I know I have them all :)

thanks,

greg k-h
