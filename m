Return-Path: <linux-kernel-owner+w=401wt.eu-S1752379AbYLWWEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbYLWWEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 17:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYLWWDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 17:03:55 -0500
Received: from plexity.net ([206.123.115.38]:41924 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbYLWWDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 17:03:55 -0500
Date: Tue, 23 Dec 2008 22:03:43 +0000
From: Deepak Saxena <dsaxena@plexity.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: TSC not updating after resume: Bug or Feature?
Message-ID: <20081223220343.GA27098@plexity.net>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net> <alpine.LFD.2.00.0812212217220.3739@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812212217220.3739@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2008 at 10:19:12PM +0100, Thomas Gleixner wrote:
> > of cycles (~2000 ftrace entries). From following the ftrace, what is 
> > happening is that the clocksource is not updated until we run the cpu_idle() 
> > thread due to an explicit scheduling operation in the resume path that occurs 
> > via call to msleep from pci_set_power_state().  As I'm still fully groking the 
> > timekeeping code, the question(s) I have is whether this is expected behaviour 
> > and I should not assume valid timestamp data in the initial bits of the suspend path, 
> > whether this is an OLPC-specific bug, or whether I've uncovered a generic bug in 
> > the timekeeping implementation.  This is on 2.6.27.7 as I've not gotten 28-rc 
> > up and running on the XO but can move that up in priority if this behaviour
> > is different in newer kernels.
> 
> Can you please upload the full trace somewhere ? 
> 
> Thanks,

Thomas,

Sorry for the delayed response...travelling and have very limited
connectivity. I will read the thread in detail when back online in a
few days.

http://dev.laptop.org/~dsaxena/suspend-trace-1267

~Deepak

