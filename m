Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbZCVVnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbZCVVnV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 17:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbZCVVnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 17:43:11 -0400
Received: from smtp1.Stanford.EDU ([171.67.219.81]:44064 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbZCVVnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 17:43:10 -0400
Subject: Re: [Announce] 2.6.29-rc8-rt2
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: nando@ccrma.Stanford.EDU, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090322130937.GA22848@elte.hu>
References: <1235513895.3816.11.camel@localhost.localdomain>
	 <1235595160.9252.49.camel@localhost.localdomain>
	 <1235619922.31774.17.camel@localhost.localdomain>
	 <1236984825.10748.17.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903140845430.29264@localhost.localdomain>
	 <1237661053.3196.10.camel@localhost.localdomain>
	 <20090321184904.GA19352@elte.hu>
	 <1237662372.3574.2.camel@localhost.localdomain>
	 <1237663624.3200.3.camel@localhost.localdomain>
	 <1237687635.3424.1.camel@localhost.localdomain>
	 <20090322130937.GA22848@elte.hu>
Content-Type: text/plain
Date: Sun, 22 Mar 2009 14:43:48 -0700
Message-Id: <1237758228.18021.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-22 at 14:09 +0100, Ingo Molnar wrote:
> * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> 
> > On Sat, 2009-03-21 at 12:27 -0700, Fernando Lopez-Lezcano wrote:
> > > On Sat, 2009-03-21 at 12:06 -0700, Fernando Lopez-Lezcano wrote:
> > > > On Sat, 2009-03-21 at 19:49 +0100, Ingo Molnar wrote:
> > > > > * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> > > > > 
> > > > > > Mar 21 10:47:43 localhost kernel: kernel tried to execute NX-protected
> > > > > > page - exploit attempt? (uid: 0)
> > > > > > Mar 21 10:47:43 localhost kernel: BUG: unable to handle kernel paging
> > > > > > request at f6400800
> > > > > 
> > > > > kernel tried to execute some really weird address, probably via a 
> > > > > function pointer.
> > > > 
> > > > Strangely enough rc8-rt1 boots (almost). _Exact_ same build with the
> > > > exception of the change from rt1 -> rt2. 
> > > > 
> > > > Haldaemon does not start on boot (fails), if I login as root and start
> > > > the haldaemon service manually it starts. And then things seem to work
> > > > fine (I'm writing this email from that machine). Still investigating...
> > > 
> > > First problem was due to old firmware for the iwl3945 hardware. I
> > > updated to the latest and hal started fine (this is on fc9). 
> > > 
> > > Now another one related to xorg/drm...
> > 
> > Scratch that, I had an old version of xorg/drm installed in this 
> > particular machine and the new kernel did not like it. Seems to 
> > boot fine now... sorry for the noise.
> 
> No problem :-)
> 
> I'm wondering, do you have any theory about how the old firmware 
> cause that weird NX-fault kernel crash? For a few minutes i took it 
> for an x86 crash.

Sorry, no theories at all - I would have to be a kernel guru for that. I
was surprised the whole thing went away with the firmware upgrade (I saw
some message in /var/log/messages telling me the firmware was old) - it
did seem like something more serious. 

I hit another problem. On a quad code intel machine here at home there
is a problem during shutdown. The final shutdown dies with a traceback
(something like "rc0 was killed by SIGSEGV" or similar words at the very
end). Then I have to push the power button for x+ seconds to force a
power off. 

Should I post a picture of the screen as it is at that point, or just
send that to you and Thomas? 

-- Fernando


