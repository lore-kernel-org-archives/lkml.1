Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbXKJJ1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbXKJJ1b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 04:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbXKJJ1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 04:27:24 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:45990 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750908AbXKJJ1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 04:27:22 -0500
Date: Sat, 10 Nov 2007 18:26:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Jeff Garzik <jeff@garzik.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
Message-ID: <20071110092644.GA18968@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
	Jeff Garzik <jeff@garzik.org>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20071109230812.GA5176@uranus.ravnborg.org> <4735242B.1010801@garzik.org> <20071110075444.GA5707@uranus.ravnborg.org> <20071110082152.GA18632@linux-sh.org> <20071110092140.GJ26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071110092140.GJ26163@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 10:21:41AM +0100, Adrian Bunk wrote:
> On Sat, Nov 10, 2007 at 05:21:52PM +0900, Paul Mundt wrote:
> > If you do that, then things like randconfigs will randomly break if you
> > happen to use a toolchain targetted specifically at i386 or so.
> >...
> 
> If you want to know how to restrict randconfig to CONFIG_X86_32 with an 
> unified architecture you should either read the toplevel README in the 
> kernel sources or an older email of mine in this thread...
> 
Ah, I missed the KCONFIG_ALLCONFIG stuff, that's what I get for jumping
in to the thread late. Thanks for pointing this out, and sorry for the
noise!
