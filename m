Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbYBDWU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbYBDWU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYBDWUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:20:50 -0500
Received: from mail.gmx.net ([213.165.64.20]:53472 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753490AbYBDWUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:20:49 -0500
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Mon, 04 Feb 2008 23:20:47 +0100
From: "Gerhard Pircher" <gerhard_pircher@gmx.net>
In-Reply-To: <20080204104232.GB29484@csn.ul.ie>
Message-ID: <20080204222047.243670@gmx.net>
MIME-Version: 1.0
References: <20080201184254.174020@gmx.net> <20080201191119.GI18688@csn.ul.ie>
 <20080201200518.174050@gmx.net> <20080201202518.GJ18688@csn.ul.ie>
 <20080201210656.174030@gmx.net> <20080204104232.GB29484@csn.ul.ie>
Subject: Re: Commit for mm/page_alloc.c breaks boot process on my machine
To: Mel Gorman <mel@csn.ul.ie>
X-Authenticated: #6097454
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19QsuNN6g1QDqfgDC7AREzXZ6jFzghM6HFTHtGFu4
 aKss2Wh3zjKUp876ObOj+sqYfOz7Ko7bCV5A== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: i72VdB5oPTR+LBk5bDIwIOs5c2tpZEtx
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
> Datum: Mon, 4 Feb 2008 10:42:32 +0000
> Von: Mel Gorman <mel@csn.ul.ie>
> An: Gerhard Pircher <gerhard_pircher@gmx.net>
> CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
> Betreff: Re: Commit for mm/page_alloc.c breaks boot process on my machine

> > > > > 2. Any chance of seeing a dmesg log?
> > > > That's a little bit of a problem. The kernel log in memory doesn't
> > > > show any kernel oops, but is also fragmented (small fragments seem
> > > > to have been overwritten with 0x0).
> > > 
> > > err, that doesn't sound very healthy.
> >
> > Yeah, I know. But the platform code hasn't changed much when porting it
> > from arch/ppc to arch/powerpc. That's why I'm a little bit lost in this
> > case. :-)
> > 
> 
> I'm at a bit of a loss to guess what might have changed in powerpc code
> that would explain this. I've added the linuxppc-dev mailing list in
> case they can make a guess.
Yes, I'll try to get some comments on the linuxppc-dev mailing list.

> I think you are also going to need to start bisecting searching
> specifically for the patch that causes these overwrites.
I think I had a similar problem with kernel v2.6.23, too and therefore
waited for kernel 2.6.24. So the problem may exist since a long time.

> It's a virtual address so it depends on the value of CONFIG_KERNEL_START
> as to whether this is a user program address or not.
AFAIK start_kernel() is called very early in the boot process, were no
user or kernel thread is active. I also wonder why the kernel crashes when
the mem boot option is used. Let's see what the linuxppc-dev people say.

Thanks for your help!

Gerhard

-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört?
Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger
