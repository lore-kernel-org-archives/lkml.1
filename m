Return-Path: <linux-kernel-owner+w=401wt.eu-S1946052AbXBBU0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946052AbXBBU0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 15:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423207AbXBBU0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 15:26:17 -0500
Received: from www.osadl.org ([213.239.205.134]:60668 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423203AbXBBU0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 15:26:16 -0500
Subject: Re: dynticks + iptables almost stops the boot process [was: Re:
	2.6.20-rc6-mm3]
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Mattia Dongili <malattia@linux.it>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, netdev@vger.kernel.org,
       netfilter-devel@lists.netfilter.org
In-Reply-To: <20070202191802.GA4262@inferi.kami.home>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	 <20070131215241.GB2890@inferi.kami.home>
	 <20070131232130.GC4137@inferi.kami.home>
	 <1170358572.29240.292.camel@localhost.localdomain>
	 <1170360101.29240.297.camel@localhost.localdomain>
	 <20070201211137.GA2830@inferi.kami.home>
	 <1170369202.29240.339.camel@localhost.localdomain>
	 <20070202191802.GA4262@inferi.kami.home>
Content-Type: text/plain
Date: Fri, 02 Feb 2007 21:27:14 +0100
Message-Id: <1170448034.29240.364.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-02 at 20:18 +0100, Mattia Dongili wrote:
> > May I ask you for another test ? Please turn on high resolution timers
> > and check, if the same strange behaviour is happening.
> 
> Yep, here we go again. Still seeing long stalls but no negative expires
> offset.
> Actually one more test I did is disabling my iptables script and the
> boot process went fine. The script is just:

Mattia,

I have it halfways reproducible now and I'm working to find the root
cause. Thanks for providing the info.

	tglx


