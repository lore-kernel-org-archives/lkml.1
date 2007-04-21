Return-Path: <linux-kernel-owner+w=401wt.eu-S1751131AbXDUJlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbXDUJlL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 05:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbXDUJlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 05:41:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52436 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbXDUJlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 05:41:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [2/2] 2.6.21-rc7: known regressions
Date: Sat, 21 Apr 2007 11:45:04 +0200
User-Agent: KMail/1.9.5
Cc: Dave Jones <davej@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>, gregkh@suse.de
References: <20070416003723.GM3691@stusta.de> <20070420172147.GC20118@redhat.com> <4629547D.9090404@goop.org>
In-Reply-To: <4629547D.9090404@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704211145.05827.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 21 April 2007 02:02, Jeremy Fitzhardinge wrote:
> Dave Jones wrote:
> > On Fri, Apr 20, 2007 at 10:16:54AM -0700, Jeremy Fitzhardinge wrote:
> >  > Dave Jones wrote:
> >  > >  > Andi, I think.  I've got his firstfloor.org patches applied to this kernel.
> >  > >
> >  > > Ah, I saw you patched in CFS too, and thought it may be related.
> >  > >   
> >  > 
> >  > Well, I have CONFIG_FB_BACKLIGHT enabled, and it still works.
> >  > 
> >  > Maybe there's something in Andi's queue which is making it work?
> >
> > Shrug, I'm out of ideas.  I'm hoping that it'll magically start working
> > when people start flushing their git trees for .22
> > Maybe that'll yield a clue for something that can be backported to .21.x
> > because right now, I'm completely puzzled.
> 
> Well, it seemed reliable, but I just got a resume failure.  Different
> from any previous symptom I've seen:
> 
> Intel machine check architecture supported
> Intel machine check reporting enabled enabled on CPU#1
> Back to C!
> <hang>

Hmm, looks like something in device_power_up() went awry.  Probably in
sysdev_resume().

Greetings,
Rafael
