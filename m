Return-Path: <linux-kernel-owner+w=401wt.eu-S1759372AbXIZOwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372AbXIZOwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbXIZOwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:52:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39308 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbXIZOwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:52:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86-64: Disable local APIC timer use on AMD systems with C1E
Date: Wed, 26 Sep 2007 17:06:51 +0200
User-Agent: KMail/1.9.5
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Andi Kleen <ak@suse.de>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, Len Brown <lenb@kernel.org>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>
References: <1190749021.17409.35.camel@chaos> <200709252332.41710.rjw@sisk.pl> <20070926083107.GB10713@elte.hu>
In-Reply-To: <20070926083107.GB10713@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709261706.52761.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 26 September 2007 10:31, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Tuesday, 25 September 2007 22:55, Thomas Gleixner wrote:
> > > On Tue, 2007-09-25 at 22:55 +0200, Rafael J. Wysocki wrote:
> > > > I have reworked the patch a bit so that it applies on top of 2.6.23-rc8-mm1
> > > > and compiles (my version is attached).
> > > > 
> > > > With this patch applied, the kernel boots correctly on the nx6325.
> > > 
> > > I know. It's basically enforced "noapictimer". 
> > > 
> > > But this still does not explain why your nasty box booted current
> > > mainline with "apicmaintimer" on the kernel command line.
> > 
> > Now it doesn't do that any more.
> > 
> > As I wrote in the other thread, I think that _sometimes_ the CPU 
> > doesn't enter the C1E state (or how it's called) and then the box 
> > boots and works.
> 
> Can you see any correlation between being on AC or on battery and this 
> bug occuring?

No.  All tests were done with the AC power supply plugged in.

> Sometimes the BIOS might even do C states depending on  
> whether the box was booted up on AC or on battery. (and sometimes the 
> kernel calibrates things differently when booting up on battery [lower 
> speed] - so this can have an effect too.)

On my box there are hidden history effects related to other things too (eg.
sometimes after a fresh boot the processor generates lots of ACPI events
such that it takes 25% of CPU power to handle them alone).

Greetings,
Rafael
