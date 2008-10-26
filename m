Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbYJZRvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbYJZRvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 13:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYJZRvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 13:51:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54711 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbYJZRvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 13:51:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Bug in workqueues [was: Usb devices randomly aren't detected with 2.6.28-rc1-git1]
Date: Sun, 26 Oct 2008 18:55:46 +0100
User-Agent: KMail/1.9.9
Cc: "Mikko C." <mikko.cal@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
References: <Pine.LNX.4.44L0.0810261327170.25044-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0810261327170.25044-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810261855.47580.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 26 of October 2008, Alan Stern wrote:
> This is no longer a USB issue, so I'm asking for help from the general 
> kernel community.  Background can be found in Bugzilla #11853.
> 
> On Sun, 26 Oct 2008, Mikko C. wrote:
> 
> > Mikko C. ha scritto:
> > > Alan Stern ha scritto:
> > >>
> > >> I don't see anything in there that looks particularly suspicious.  
> > >> The nature of your errors suggests that the default workqueue has 
> > >> crashed or hung, but it shows up okay in the dump.  Are you sure this 
> > >> dump was made when the devices failed to appear?
> > >>
> > >>  
> > >
> > > Yes, I'm 100% sure.
> > >
> > >> What happens when you try to rmmod the ALSA modules?  Does rmmod 
> > >> crash with an error or does it hang?  If it hangs, can you get 
> > >> another task dump showing the hanging process?
> > >>   
> > >
> > > Whenever I try rmmoding something, it hangs (no crash) and I'm not 
> > > able to do anything, beside moving the mouse.
> > > I posted here: http://marc.info/?l=linux-kernel&m=122502213503239&w=4
> > > but that's probably not enough, so I will try getting a full dump.
> > >
> > Here it is: http://bugzilla.kernel.org/attachment.cgi?id=18452&action=view
> 
> The task dump shows rmmod waiting for flush_workqueue().  But the 
> events/0 task doesn't appear to be hung, and the task dump taken before 
> running rmmod shows events/0 doing something different.
> 
> So apparently flush_workqueue() isn't working.

Let's make that more visible (adding CCs). :-)

Thanks,
Rafael
