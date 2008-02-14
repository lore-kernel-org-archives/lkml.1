Return-Path: <linux-kernel-owner+w=401wt.eu-S934274AbYBNWih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934274AbYBNWih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbYBNWi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:38:28 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:42364 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbYBNWi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:38:26 -0500
Date: Thu, 14 Feb 2008 23:38:32 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: David Miller <davem@davemloft.net>, greg@kroah.com,
       torvalds@linux-foundation.org, jeff@garzik.org, arjan@infradead.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: distributed module configuration [Was: Announce: Linux-next (Or Andrew's dream :-))]
Message-ID: <20080214223832.GA23149@uranus.ravnborg.org>
References: <20080212174824.GA1919@kroah.com> <20080212.164149.209357519.davem@davemloft.net> <20080213084541.GA8091@uranus.ravnborg.org> <200802140156.15325.zippel@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802140156.15325.zippel@linux-m68k.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 01:56:13AM +0100, Roman Zippel wrote:
> Hi,
> 
> On Wednesday 13. February 2008, Sam Ravnborg wrote:
> 
> > config foo
> > 	tristate "do you want foo?"
> > 	depends on USB && BAR
> > 	module
> > 	  obj-$(CONFIG_FOO) += foo.o
> > 	  foo-y := file1.o file2.o
> > 	help
> > 	  foo will allow you to explode your PC
> 
> I'm more thinking about something like this:
> 
> module foo [FOO]
> 	tristate "do you want foo?"
> 	depends on USB && BAR
> 	source file1.c
> 	source file2.c if BAZ
> 
> Avoiding direct Makefile fragments would give us far more flexibility in the 
> final Makefile output.

Much better and now I see it I recall you posted something
along these lines before.
Is this something that you plan to look into implementing?

I can do the kbuild bits but I need you to do the kconfig
stuff (which is by far the biggest effort too).

It would be much appreciated to get this.

	Sam
