Return-Path: <linux-kernel-owner+w=401wt.eu-S1751657AbXDSHcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657AbXDSHcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbXDSHcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:32:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:44584 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752277AbXDSHcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:32:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX195pN1mSbh5KBE6iwz8Gd9YaMDt5rF9KiVcCkgcg7
	XdDwdqKAzOHwzO
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
	Scheduler [CFS]
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070419070921.GA28528@elte.hu>
References: <20070418055525.GS11115@waste.org>
	 <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
	 <20070418152355.GU11115@waste.org>
	 <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
	 <20070418174945.GA7930@elte.hu> <20070418175936.GA11980@elte.hu>
	 <alpine.LFD.0.98.0704181223190.2828@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0704181304250.25880@alien.or.mcafeemobile.com>
	 <20070418214816.GA10902@elte.hu>
	 <1176965560.6408.60.camel@Homer.simpson.net>
	 <20070419070921.GA28528@elte.hu>
Content-Type: text/plain
Date: Thu, 19 Apr 2007 09:32:17 +0200
Message-Id: <1176967937.6408.81.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 09:09 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > With a heavily reniced X (perfectly fine), that should indeed solve my 
> > daily usage pattern nicely (always need godmode for shells, but not 
> > for mozilla and ilk. 50/50 split automatic without renice of entire 
> > gui)
> 
> how about the first-approximation solution i suggested in the previous 
> mail: to add a per UID default nice level? (With this default defaulting 
> to '-10' for all root-owned processes, and defaulting to '0' for 
> everything else.) That would solve most of the current CFS regressions 
> at hand.

That would make my kernel builds etc interfere with my other self's
surfing and whatnot.  With it by EUID, when I'm surfing or whatnot, the
X portion of my Joe-User activity pushes the compile portion of root
down in bandwidth utilization automagically, which is exactly the right
thing, because the root me in not as important as the Joe-User me using
the GUI at that time.  If the idea of X disturbing root upsets some,
they can move X to another UID.  Generally, it seems perfect for here.

	-Mike

