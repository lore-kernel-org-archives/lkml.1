Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbXI3P6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbXI3P6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757865AbXI3P6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:58:12 -0400
Received: from www.tglx.de ([62.245.132.106]:40134 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423AbXI3P6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:58:11 -0400
Date: Sun, 30 Sep 2007 17:58:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Helge Hafting <helge.hafting@aitel.hist.no>
cc: linux-kernel@vger.kernel.org
Subject: Re: x86-64 sporadic hang in 2.6.23rc7 and 2.6.22
In-Reply-To: <46FE5C98.1030507@aitel.hist.no>
Message-ID: <alpine.LFD.0.9999.0709301755080.3142@localhost.localdomain>
References: <46F8273B.8030904@aitel.hist.no> <1190669351.4035.254.camel@chaos> <46FE5C98.1030507@aitel.hist.no>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2007, Helge Hafting wrote:
> Thomas Gleixner wrote:
> > > I have gone back to 2.6.22rc4, which seems to work.
> > > 
> > > This is a single opteron, although on a dual-slot board.
> > >     
> > 
> > Can you switch to serial console, so we can get some information out of
> > that box? Sysrq-B is working, so we can get info from other sysrq
> > functions as well.
> >   
> I didn't need the serial - it crashes during console work too.
> I think a "make clean" was in progress at the time. There must be work going
> on in order to crash.
> 
> This time 2.6.22rc4 died on me with a general protection fault
> 
> I got two reports, the first one scrolled partially off screen but
> the whole trace was there:

That's why I asked for a serial console. That way we can get all the
information from the reports including the register dumps ....

> Then I got:
> spinlock lockup on cpu #0, kswapd 0/212

That's probably caused by the previous one.

       tglx
