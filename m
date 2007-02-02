Return-Path: <linux-kernel-owner+w=401wt.eu-S1946063AbXBBUoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946063AbXBBUoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 15:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946062AbXBBUoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 15:44:38 -0500
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:59365 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946060AbXBBUoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 15:44:37 -0500
Date: Fri, 2 Feb 2007 21:43:44 +0100
From: Mattia Dongili <malattia@linux.it>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, netdev@vger.kernel.org,
       netfilter-devel@lists.netfilter.org
Subject: Re: dynticks + iptables almost stops the boot process [was: Re: 2.6.20-rc6-mm3]
Message-ID: <20070202204344.GB4262@inferi.kami.home>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	mingo@redhat.com, netdev@vger.kernel.org,
	netfilter-devel@lists.netfilter.org
References: <20070129204528.eb8d695e.akpm@osdl.org> <20070131215241.GB2890@inferi.kami.home> <20070131232130.GC4137@inferi.kami.home> <1170358572.29240.292.camel@localhost.localdomain> <1170360101.29240.297.camel@localhost.localdomain> <20070201211137.GA2830@inferi.kami.home> <1170369202.29240.339.camel@localhost.localdomain> <20070202191802.GA4262@inferi.kami.home> <1170448034.29240.364.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170448034.29240.364.camel@localhost.localdomain>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.20-rc6-mm3-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 09:27:14PM +0100, Thomas Gleixner wrote:
> On Fri, 2007-02-02 at 20:18 +0100, Mattia Dongili wrote:
> > > May I ask you for another test ? Please turn on high resolution timers
> > > and check, if the same strange behaviour is happening.
> > 
> > Yep, here we go again. Still seeing long stalls but no negative expires
> > offset.
> > Actually one more test I did is disabling my iptables script and the
> > boot process went fine. The script is just:
> 
> Mattia,
> 
> I have it halfways reproducible now and I'm working to find the root
> cause. Thanks for providing the info.

Great, I'm obviously available to test any patch :)

-- 
mattia
:wq!
