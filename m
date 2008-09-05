Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbYIEAF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbYIEAF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 20:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYIEAFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 20:05:23 -0400
Received: from iabervon.org ([66.92.72.58]:38362 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbYIEAFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 20:05:22 -0400
Date: Thu, 4 Sep 2008 20:05:20 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
In-Reply-To: <alpine.LNX.1.00.0809031250561.19665@iabervon.org>
Message-ID: <alpine.LNX.1.00.0809041957430.19665@iabervon.org>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz> <20080902083940.ZZRA012@mailhub.coreip.homeip.net>
 <alpine.LNX.1.00.0809021200470.19665@iabervon.org> <20080903102047.ZZRA012@mailhub.coreip.homeip.net> <alpine.LNX.1.00.0809031250561.19665@iabervon.org>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Daniel Barkalow wrote:

> On Wed, 3 Sep 2008, Dmitry Torokhov wrote:
> 
> > On Tue, Sep 02, 2008 at 12:16:15PM -0400, Daniel Barkalow wrote:
> > > legacy mode only has a bug that doesn't matter to Windows, and active mux 
> > > may have some of the usual problems but nothing I particularly noticed.
> > > 
> > > I noticed that, when my i8042 would stop working, it would generally have 
> > > just delivered one mouse interrupt to CPU1 after never previously doing 
> > > so. Perhaps there's some sort of deadlock in the Linux i8042 driver when 
> > > both cores are unexpectedly getting interrupts from the two devices at 
> > > once? I could understand there being a Linux bug only triggered by quirky 
> > > hardware that only applies to legacy mode, which was just uncovered by 
> > > this patch.
> > >
> > 
> > I am not sure, internally we the kernel still deals with 2 interrupt
> > sources (KBD and AUX) regardless whether it is in legacy or active
> > multiplexing mode...
> > 
> > Does it take long to trigger the bug? You coudl try doing "echo 1 >
> > /sys/modules/i8042/parameters/debug" and thend me dmesg or
> > /var/log/messages after the bug was triggered - I might see something
> > there. But please be aware that if you send me such a log I can decode
> > everything that you have been typing...
> 
> It's usually within an hour of the right usage pattern. I'll try to 
> trigger it with debugging on while not typing anything secret Thursday 
> evening.

Attached. This has me typing some unimportant stuff, and then it sticks, 
then I plug in a USB keyboard, then I tried unbinding the i8042 and 
binding it again; the audio stuttered briefly, and recovered, and I did it 
again, and then saved this log.

	-Daniel
*This .sig left intentionally blank*
