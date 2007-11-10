Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbXKJUpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbXKJUpI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 15:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbXKJUo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 15:44:57 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:41684 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbXKJUo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 15:44:56 -0500
Date: Sat, 10 Nov 2007 21:46:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Jeff Garzik <jeff@garzik.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
Message-ID: <20071110204635.GB13140@uranus.ravnborg.org>
References: <20071109230812.GA5176@uranus.ravnborg.org> <4735242B.1010801@garzik.org> <20071110075444.GA5707@uranus.ravnborg.org> <20071110082152.GA18632@linux-sh.org> <47356AD5.4070102@garzik.org> <20071110084447.GA18780@linux-sh.org> <473615F5.5090908@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473615F5.5090908@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 12:35:01PM -0800, H. Peter Anvin wrote:
> 
> HOWEVER, I think the right thing for allyesconfig, allmodconfig, 
> randconfig, etc. is to be able to override specific variables.  Right 
> now, one has to use indirection via a file, which is a bit clumsy; it 
> would be better if one could do "make allyesconfig CONFIG_X86_64=y" or 
> somesuch.

See patch-set I just sent out :-)

> 
> In fact, we should be able to get rid of ARCH entirely;  CONFIG_ options 
> have the huge advantage that they're saved in a file, and you don't have 
> to type them on every make run. The only option that I can't see us 
> getting rid of easily is HOSTCC, since it is used before config is run, 
> but probably something clever can be done there, too.

My long term plan is to enable the above.
I had planned to do a lot for 2.6.25 but all this x86 stuff have eaten
too much time. And I have plenty of kbuild stuff in my
inbox awaiting some attention...

	Sam
