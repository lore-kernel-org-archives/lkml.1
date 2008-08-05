Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbYHEN67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbYHEN67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 09:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYHEN6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 09:58:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38020 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbYHEN6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 09:58:51 -0400
Subject: Re: HPET regression in 2.6.26 versus 2.6.25
From: Peter Zijlstra <peterz@infradead.org>
To: David Witbrodt <dawitbro@sbcglobal.net>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
In-Reply-To: <631258.35580.qm@web82103.mail.mud.yahoo.com>
References: <631258.35580.qm@web82103.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 15:58:53 +0200
Message-Id: <1217944733.3589.120.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Let's CC people, so that they'll at least see this mail
  when they're back from holidays ]

On Mon, 2008-08-04 at 16:57 -0700, David Witbrodt wrote:
> Hello,
> 
> [Please CC me if you reply, for I am not subscribed to LKML.]
> 
> This is my first time posting to LKML.
> 
> I am a Debian user.  The sources for 2.6.26 recently became available
> in the Debian unstable repositories.  Trying them out by building
> custom kernels (think 'make oldconfig'), I found that one machine 
> worked while another froze early in boot.  No oops, no error msg of
> any kind, just a hard freeze without even Magic SysRq working!
> 
> I suspected a dumb config error on my part, but found that the Debian
> stock kernel exhibited the same problem.  So I filed a bug report in
> the Debian BTS:
> 
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=493479
> 
> There is much info about my hardware and configs there, but I can
> repost them here if that is helpful.  The machine that works with
> 2.6.26 has a Gigabyte GA-M59SLI-S5 mboard; the broken machine has an
> ECS AMD690GM-M2 mboard.
> 
> After much experimenting with various configs and rebuilds, I was
> finally able to discover that a kernel boot parameter,
> "hpet=disabled", allowed me to boot on the troublesome machine.  
> Both custom and Debian stock kernels of version 2.6.25 (most recently
> based on 2.6.25.10) work fine on this machine, no problem with HPET.
> 
> A member of the Debian kernel team (Bastian Blank) tried to help, but
> ended up suggesting bisecting using 'git'.  I am not (yet) a developer
> so I was not really thinking of getting that deeply involved, but I
> spent so much time trying to track this problem on Saturday night and
> all day Sunday, that I decided to give it a try!
> 
> Starting with Linus' instructions here,
>   http://lkml.org/lkml/2007/7/10/248
> 
> I ran: 
>   git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
> 
> and:
>   git checkout v2.6.25


Since you have that git tree, could you try to see if the latest -git
still has this problem?

