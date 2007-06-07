Return-Path: <linux-kernel-owner+w=401wt.eu-S933873AbXFGQyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873AbXFGQyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763296AbXFGQwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:52:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53009 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765429AbXFGQwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:52:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Greaves <david@dgreaves.com>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
Date: Thu, 7 Jun 2007 18:58:03 +0200
User-Agent: KMail/1.9.5
Cc: Mark Lord <lkml@rtr.ca>, Tejun Heo <htejun@gmail.com>,
       Duane Griffin <duaneg@dghda.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>
References: <46608E3F.4060201@dgreaves.com> <466817EF.7090707@rtr.ca> <46682221.8070705@dgreaves.com>
In-Reply-To: <46682221.8070705@dgreaves.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706071858.05000.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 7 June 2007 17:20, David Greaves wrote:
> Mark Lord wrote:
> > Tejun Heo wrote:
> >>
> >> Can you setup serial console and/or netconsole (not sure whether this
> >> would work tho)?
> > 
> > Since he has good console output already, capturable by digicam,
> > I think a better approach might be to provide a patch with extra 
> > instrumentation..
> > You know.. progress messages and the like, so we can see at what step
> > things stop working.  Or would that not help ?
> > 
> > David, does scrollback work on your dead console?
> 
> hmmmm, scrollback doesn't currently _do_ anything.
> 
> But the messages didn't scroll there, they just appear (as the memory is 
> restored I assume). The same messages appear during the fail-to-suspend case too.
> 
> Linus said at one point:
>  > Ok, it wasn't a hidden oops. The DISABLE_CONSOLE_SUSPEND=y thing sometimes
>  > shows oopses that are otherwise hidden, but at other times it just causes
>  > more problems (hard hangs when trying to display something on a device
>  > that is suspended, or behind a bridge that got suspended).
> 
>  > In your case, the screen output just shows normal resume output, and it
>  > apparently just hung for some unknown reason. It *may* be worth trying to
>  > do a SysRQ + 't' thing to see what tasks are running (or rather, not
>  > running), but since you won't be able to capture it, it's probably not
>  > going to be useful.
> 
> So I've since removed DISABLE_CONSOLE_SUSPEND=y
> Should I put it back?

I would do that.

Apart from this, your observations don't directly imply that XFS is to blame
here.  It might be involved somehow, but it's also possible that RAID6 alone
would suffice to trigger the problem.

Greetings,
Rafael
