Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbXINUAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbXINUAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 16:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbXINUAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 16:00:09 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:54611 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbXINUAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 16:00:08 -0400
Date: Fri, 14 Sep 2007 22:01:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22.6: still seeing section mismatch warnings
Message-ID: <20070914200132.GA4554@uranus.ravnborg.org>
References: <20070912160017.GA3948@janus> <20070913070200.GA23330@uranus.ravnborg.org> <20070913083505.GA12944@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913083505.GA12944@janus>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 10:35:05AM +0200, Frank van Maarseveen wrote:
> On Thu, Sep 13, 2007 at 09:02:00AM +0200, Sam Ravnborg wrote:
> > On Wed, Sep 12, 2007 at 06:00:17PM +0200, Frank van Maarseveen wrote:
> > > I'm still seeing the warnings below (2.6.22 started off with lots of
> > > section mismatch warning) but I have no idea if it is safe to ignore
> > > these:
> > > 
> > > WARNING: arch/i386/kernel/built-in.o(.text+0xea62): Section mismatch: reference to .init.data:trampoline_end (between 'setup_trampoline' and 'cpu_coregroup_map')
> > > WARNING: arch/i386/kernel/built-in.o(.text+0xea67): Section mismatch: reference to .init.data:trampoline_data (between 'setup_trampoline' and 'cpu_coregroup_map')
> > > WARNING: arch/i386/kernel/built-in.o(.text+0xea79): Section mismatch: reference to .init.data:trampoline_data (between 'setup_trampoline' and 'cpu_coregroup_map')
> > > WARNING: arch/i386/kernel/built-in.o(.exit.text+0x26): Section mismatch: reference to .init.text: (between 'cache_remove_dev' and 'ffh_cstate_exit')
> > > WARNING: arch/i386/kernel/built-in.o(.data+0xee0): Section mismatch: reference to .init.text: (between 'thermal_throttle_cpu_notifier' and 'mce_work')
> > > WARNING: kernel/built-in.o(.text+0x1b415): Section mismatch: reference to .init.text: (between 'kthreadd' and 'init_waitqueue_head')
> > > 
> > > 
> > > gcc version 3.4.6 (Debian 3.4.6-5)
> > 
> > Does not appear with an allmodconfig.
> > Care to send me your .config then I may take a look.
> 
> See attached .config

Tried to build a fres i386 kernel with your config.
As I'm running on latest from Linus I could see that all your
reported warnings were gone.
But one new warning crept in for which I have prepared a patch -
to be submitted when I have test-builded a bit more.

Anyway - thanks for reporting and sending your .config.

	Sam
