Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbZCAKmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbZCAKmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 05:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZCAKl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 05:41:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:59301 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbZCAKl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 05:41:58 -0500
Subject: Re: [git-pull -tip] x86: Basic AMD Support for performance counters
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20090301083616.GA1742@elte.hu>
References: <1235756278.3914.9.camel@localhost.localdomain>
	 <20090228094018.GF12095@elte.hu> <20090228134434.GA32473@elte.hu>
	 <20090301083616.GA1742@elte.hu>
Content-Type: text/plain
Date: Sun, 01 Mar 2009 16:11:27 +0530
Message-Id: <1235904087.3213.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-01 at 09:36 +0100, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Seems to be working fine, here's the output from an Athlon 64 
> > 3200+ (Sempron) box:
> > 
> >  Performance counter stats for 'ls':
> > 
> >       17.420811  task clock ticks     (msecs)
> > 
> >               0  CPU migrations       (events)
> >              12  context switches     (events)
> >             583  pagefaults           (events)
> >        29760299  CPU cycles           (events)
> >        29401642  instructions         (events)
> >        12698498  cache references     (events)
> >           66269  cache misses         (events)
> > 
> >  Wall-clock time elapsed:   687.999988 msecs
> 
> The patches cause a crash on another system - an Opteron system 
> spontaneous reboots at this point during early bootup:
> 
> CPU 0/0x4 -> Node 0
> tseg: 00cfe00000
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> using C1E aware idle routine
> AMD Performance Monitoring support detected.
> ... num counters:    4
> ... value mask:      0000000000000000
> ... fixed counters:  0
> ... counter mask:    000000000000000f
> ACPI: Core revision 20081204
> ftrace: converting mcount calls to 0f 1f 44 00 00
> ftrace: allocating 16365 entries in 129 pages
> Setting APIC routing to physical flat
> masked ExtINT on CPU#0
> ENABLING IO
> [reboot]
> 

Can you please share your config file.

Thanks,

--
JSR

