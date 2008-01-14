Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbYANUBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbYANUBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 15:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYANUBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 15:01:24 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:58183 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbYANUBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 15:01:24 -0500
Date: Mon, 14 Jan 2008 21:01:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>, rjw@sisk.pl,
       pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
Message-ID: <20080114200126.GB9257@uranus.ravnborg.org>
References: <20080110124702.GF28740@does.not.exist> <p73fxx5omck.fsf@bingen.suse.de> <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150103.GA2700@elte.hu> <20080114182052.GB9847@does.not.exist> <20080114191009.GB2288@elte.hu> <20080114195258.GC9847@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114195258.GC9847@does.not.exist>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 09:52:58PM +0200, Adrian Bunk wrote:
> On Mon, Jan 14, 2008 at 08:10:09PM +0100, Ingo Molnar wrote:
> > 
> > * Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > > for example, in current -git, could you tell me why this triggers:
> > > > 
> > > >  WARNING: vmlinux.o(.text+0x87e2a): Section mismatch: reference to 
> > > >           .init.text: (between 'process_zones' and 'setup_per_cpu_pageset')
> > > > 
> > > > and how to resolve it? I had a quick look and it was not obvious to me.
> > > 
> > > Please send the .config.
> > 
> > 'make allyesconfig' and disable CONFIG_HOTPLUG=y.
> 
> Works for me without the warning.
> 
> Wait, I remember something @#$%#@$!!!:
> 'make allyesconfig' on x86 became ambiguously.
> 
> If you have by chance a 64bit CPU that would explain why I didn't get it.
> 
> @Sam:
> Can you fix the bug that menuconfig does not let me enable CONFIG_64BIT?

make ARCH=x86_64 allyesconfig
will set CONFIG_64BIT for you - no?

	Sam
