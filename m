Return-Path: <linux-kernel-owner+w=401wt.eu-S1030587AbXCEQor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030587AbXCEQor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030580AbXCEQoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:44:46 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:48842 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030591AbXCEQop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:44:45 -0500
Subject: Re: [5/6] 2.6.21-rc2: known regressions
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Soeren Sonnenburg <kernel@nn7.de>
In-Reply-To: <20070305152749.GA22258@elte.hu>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <20070305015040.GJ3441@stusta.de> <20070305075747.GA19838@elte.hu>
	 <20070305001358.2eebbfae.akpm@linux-foundation.org>
	 <1173108303.31337.18.camel@imap.mvista.com>
	 <20070305152749.GA22258@elte.hu>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 08:42:16 -0800
Message-Id: <1173112936.31337.26.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 16:27 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > > > FYI, this is not a "wont boot" problem, this should be a "NMI 
> > > > watchdog does not work" problem - which has far lower severity. 
> > > > Also, Thomas did a fix for this which is now in -mm.
> > > 
> > > yup, you should be able to cross this one off, Adrian.  The fix 
> > > worked for me, at least.
> > 
> > I didn't see a fix for this one go by .. I'll check the usual places I 
> > guess ..
> 
> find it below.

This fix gets the NMI to tick like the timer (in /proc/interrupts) ..
However, now that it's ticking I don't think it's actually working
properly ..

I used this simple test case given by you a long time ago,

main ()
{
iopl(3);
for (;;) 
        asm("cli");

}

This doesn't look like a regression tho, 2.6.19-rc6 has the same
behavior ..

Daniel

