Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbZCVCHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbZCVCHR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 22:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbZCVCG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 22:06:59 -0400
Received: from smtp1.Stanford.EDU ([171.67.219.81]:50779 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbZCVCG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 22:06:59 -0400
Subject: Re: [Announce] 2.6.29-rc8-rt2
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: nando@ccrma.Stanford.EDU, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1237663624.3200.3.camel@localhost.localdomain>
References: <1235437021.4462.25.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902241120320.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241729590.3523@localhost.localdomain>
	 <1235513895.3816.11.camel@localhost.localdomain>
	 <1235595160.9252.49.camel@localhost.localdomain>
	 <1235619922.31774.17.camel@localhost.localdomain>
	 <1236984825.10748.17.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903140845430.29264@localhost.localdomain>
	 <1237661053.3196.10.camel@localhost.localdomain>
	 <20090321184904.GA19352@elte.hu>
	 <1237662372.3574.2.camel@localhost.localdomain>
	 <1237663624.3200.3.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 19:07:15 -0700
Message-Id: <1237687635.3424.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-21 at 12:27 -0700, Fernando Lopez-Lezcano wrote:
> On Sat, 2009-03-21 at 12:06 -0700, Fernando Lopez-Lezcano wrote:
> > On Sat, 2009-03-21 at 19:49 +0100, Ingo Molnar wrote:
> > > * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> > > 
> > > > Mar 21 10:47:43 localhost kernel: kernel tried to execute NX-protected
> > > > page - exploit attempt? (uid: 0)
> > > > Mar 21 10:47:43 localhost kernel: BUG: unable to handle kernel paging
> > > > request at f6400800
> > > 
> > > kernel tried to execute some really weird address, probably via a 
> > > function pointer.
> > 
> > Strangely enough rc8-rt1 boots (almost). _Exact_ same build with the
> > exception of the change from rt1 -> rt2. 
> > 
> > Haldaemon does not start on boot (fails), if I login as root and start
> > the haldaemon service manually it starts. And then things seem to work
> > fine (I'm writing this email from that machine). Still investigating...
> 
> First problem was due to old firmware for the iwl3945 hardware. I
> updated to the latest and hal started fine (this is on fc9). 
> 
> Now another one related to xorg/drm...

Scratch that, I had an old version of xorg/drm installed in this
particular machine and the new kernel did not like it. Seems to boot
fine now... sorry for the noise. 

-- Fernando


