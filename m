Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbYCTUxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbYCTUxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 16:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbYCTUxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 16:53:01 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33855 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbYCTUxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 16:53:00 -0400
Date: Thu, 20 Mar 2008 11:40:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
Message-ID: <20080320104019.GA6870@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0803182228520.10154-100000@netrider.rowland.org> <m1ve3jtmxk.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ve3jtmxk.fsf@ebiederm.dsl.xmission.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-03-18 21:25:27, Eric W. Biederman wrote:
> Alan Stern <stern@rowland.harvard.edu> writes:
> 
> > On Wed, 19 Mar 2008, Rafael J. Wysocki wrote:
> >
> >> Well, I've been saying that for I-don't-remember-how-long: on my box, if you
> >> use S5 instead of entering S4, the fan doesn't work correctly after the
> >> resume.  Plain and simple.
> >> 
> >> Perhaps there's a problem with our ACPI drivers that causes this to happen,
> >> but I have no idea what that can be at the moment.
> >
> > IMO it would be worthwhile to track this down.  It's a clear indication 
> > that something is wrong somewhere.
> >
> > Could it be connected with the way the boot kernel hands control over
> > to the image kernel?  Presumably ACPI isn't prepared to deal with that
> > sort of thing during a boot from S5.  It would have to be fooled into
> > thinking the two kernels were one and the same.
> 
> It should be easy to test if it is a hand over problem, by turning off
> the laptop by placing it in S5 (shutdown -h now) and then booting same
> kernel again.

Feel free to help with testing.

I believe ACPI is simply getting confused by us overwriting memory
with that from old image. I don't see how you can emulate it with
shutdown.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
