Return-Path: <linux-kernel-owner+w=401wt.eu-S1751566AbYANU1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbYANU1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 15:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYANU1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 15:27:34 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:48240 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbYANU1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 15:27:34 -0500
Date: Mon, 14 Jan 2008 21:27:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>, rjw@sisk.pl,
       pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
Message-ID: <20080114202740.GD9257@uranus.ravnborg.org>
References: <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150103.GA2700@elte.hu> <20080114182052.GB9847@does.not.exist> <20080114191009.GB2288@elte.hu> <20080114195258.GC9847@does.not.exist> <20080114200126.GB9257@uranus.ravnborg.org> <20080114201826.GD9847@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114201826.GD9847@does.not.exist>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Can you fix the bug that menuconfig does not let me enable CONFIG_64BIT?
> > 
> > make ARCH=x86_64 allyesconfig
> > will set CONFIG_64BIT for you - no?
> 
> Yes.
> 
> But this still leaves the fact that when someone says 'allyesconfig' 
> it's no longer clear which configuration he has.
Assuming you are on an x86 box...

make allyesconfig will give you a config for same OS bit-size as you run.
make ARCH=i386 allyesconfig gives you a 32 bit config
make ARCH=x86_64 allyesconfig gives you a 64 bit config

make ARCH=x86 allyesconfig gives you a 32 bit config where you can select 64 bit.

It was seen as the best solution when unifying 32 and 64 bit stuff
and introducing support for ARCH=x86.

No-one has complained until now so most people seems to get it
or maybe they are just silent.

	Sam
