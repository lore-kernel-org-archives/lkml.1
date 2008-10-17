Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbYJQQJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbYJQQJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbYJQQJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:09:19 -0400
Received: from xenotime.net ([66.160.160.81]:46264 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754717AbYJQQJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:09:19 -0400
Date: Fri, 17 Oct 2008 09:09:15 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Uwe Hermann <uwe@hermann-uwe.de>
cc: "Randy.Dunlap" <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       mtk.manpages@gmail.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH] doc: Fix broken references to Documentation/x86 files
In-Reply-To: <20081017124216.GA4470@greenwood>
Message-ID: <Pine.LNX.4.64.0810170908120.685@shark.he.net>
References: <20081003160825.GA26167@greenwood> <Pine.LNX.4.64.0810031027070.18240@shark.he.net>
 <20081003175857.GA32504@greenwood> <20081017124216.GA4470@greenwood>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008, Uwe Hermann wrote:

> Hi,
> 
> has this patch been merged into some repository? It doesn't seem to be
> in Linus' linux-2.6 tree at least.

Hi,
I have it in a quilt patch series with a few other docs patches.
I'll send them to Linus this weekend.

> On Fri, Oct 03, 2008 at 07:58:57PM +0200, Uwe Hermann wrote:
> > The Documentation/i386 and Documentation/x86_64 directories and their
> > contents have been moved into Documentation/x86. Fix references to
> > those files accordingly.
> > 
> > Signed-off-by: Uwe Hermann <uwe@hermann-uwe.de>
> > Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> > 
> > diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
> > index 5b5aba4..84ae622 100644
> > --- a/Documentation/00-INDEX
> > +++ b/Documentation/00-INDEX
> > @@ -171,7 +171,7 @@ i2c/
> >  	- directory with info about the I2C bus/protocol (2 wire, kHz speed).
> >  i2o/
> >  	- directory with info about the Linux I2O subsystem.
> > -i386/
> > +x86/i386/
> >  	- directory with info about Linux on Intel 32 bit architecture.
> >  ia64/
> >  	- directory with info about Linux on Intel 64 bit architecture.
> > @@ -383,7 +383,7 @@ w1/
> >  	- directory with documents regarding the 1-wire (w1) subsystem.
> >  watchdog/
> >  	- how to auto-reboot Linux if it has "fallen and can't get up". ;-)
> > -x86_64/
> > +x86/x86_64/
> >  	- directory with info on Linux support for AMD x86-64 (Hammer) machines.
> >  zorro.txt
> >  	- info on writing drivers for Zorro bus devices found on Amigas.
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index 1150444..5af144c 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -100,7 +100,7 @@ parameter is applicable:
> >  	X86-32	X86-32, aka i386 architecture is enabled.
> >  	X86-64	X86-64 architecture is enabled.
> >  			More X86-64 boot options can be found in
> > -			Documentation/x86_64/boot-options.txt .
> > +			Documentation/x86/x86_64/boot-options.txt .
> >  
> >  In addition, the following text indicates that the option:
> >  
> > @@ -111,10 +111,10 @@ In addition, the following text indicates that the option:
> >  Parameters denoted with BOOT are actually interpreted by the boot
> >  loader, and have no meaning to the kernel directly.
> >  Do not modify the syntax of boot loader parameters without extreme
> > -need or coordination with <Documentation/i386/boot.txt>.
> > +need or coordination with <Documentation/x86/i386/boot.txt>.
> >  
> >  There are also arch-specific kernel-parameters not documented here.
> > -See for example <Documentation/x86_64/boot-options.txt>.
> > +See for example <Documentation/x86/x86_64/boot-options.txt>.
> >  
> >  Note that ALL kernel parameters listed below are CASE SENSITIVE, and that
> >  a trailing = on the name of any parameter states that that parameter will
> > @@ -1187,7 +1187,7 @@ and is between 256 and 4096 characters. It is defined in the file
> >  
> >  	mce		[X86-32] Machine Check Exception
> >  
> > -	mce=option	[X86-64] See Documentation/x86_64/boot-options.txt
> > +	mce=option	[X86-64] See Documentation/x86/x86_64/boot-options.txt
> >  
> >  	md=		[HW] RAID subsystems devices and level
> >  			See Documentation/md.txt.
> > @@ -1650,7 +1650,7 @@ and is between 256 and 4096 characters. It is defined in the file
> >  			See Documentation/paride.txt.
> >  
> >  	pirq=		[SMP,APIC] Manual mp-table setup
> > -			See Documentation/i386/IO-APIC.txt.
> > +			See Documentation/x86/i386/IO-APIC.txt.
> >  
> >  	plip=		[PPT,NET] Parallel port network link
> >  			Format: { parport<nr> | timid | 0 }
> > @@ -2231,7 +2231,7 @@ and is between 256 and 4096 characters. It is defined in the file
> >  			See Documentation/fb/modedb.txt.
> >  
> >  	vga=		[BOOT,X86-32] Select a particular video mode
> > -			See Documentation/i386/boot.txt and
> > +			See Documentation/x86/i386/boot.txt and
> >  			Documentation/svga.txt.
> >  			Use vga=ask for menu.
> >  			This is actually a boot loader parameter; the value is
> > diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
> > index 7228369..da86fd5 100644
> > --- a/Documentation/lguest/lguest.c
> > +++ b/Documentation/lguest/lguest.c
> > @@ -402,7 +402,7 @@ static unsigned long load_bzimage(int fd)
> >  	void *p = from_guest_phys(0x100000);
> >  
> >  	/* Go back to the start of the file and read the header.  It should be
> > -	 * a Linux boot header (see Documentation/i386/boot.txt) */
> > +	 * a Linux boot header (see Documentation/x86/i386/boot.txt) */
> >  	lseek(fd, 0, SEEK_SET);
> >  	read(fd, &boot, sizeof(boot));
> >  
> > diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
> > index b0c7b6c..89a2141 100644
> > --- a/Documentation/x86/x86_64/boot-options.txt
> > +++ b/Documentation/x86/x86_64/boot-options.txt
> > @@ -35,7 +35,7 @@ APICs
> >  
> >     nolapic	 Don't use the local APIC (alias for i386 compatibility)
> >  
> > -   pirq=...	 See Documentation/i386/IO-APIC.txt
> > +   pirq=...	 See Documentation/x86/i386/IO-APIC.txt
> >  
> >     noapictimer	 Don't set up the APIC timer
> >  
> > @@ -143,7 +143,7 @@ Non Executable Mappings
> >  SMP
> >  
> >    additional_cpus=NUM Allow NUM more CPUs for hotplug
> > -		 (defaults are specified by the BIOS, see Documentation/x86_64/cpu-hotplug-spec)
> > +		 (defaults are specified by the BIOS, see Documentation/x86/x86_64/cpu-hotplug-spec)
> >  
> >  NUMA
> >  
> > diff --git a/Documentation/x86/x86_64/fake-numa-for-cpusets b/Documentation/x86/x86_64/fake-numa-for-cpusets
> > index d1a985c..33bb566 100644
> > --- a/Documentation/x86/x86_64/fake-numa-for-cpusets
> > +++ b/Documentation/x86/x86_64/fake-numa-for-cpusets
> > @@ -10,7 +10,7 @@ amount of system memory that are available to a certain class of tasks.
> >  For more information on the features of cpusets, see Documentation/cpusets.txt.
> >  There are a number of different configurations you can use for your needs.  For
> >  more information on the numa=fake command line option and its various ways of
> > -configuring fake nodes, see Documentation/x86_64/boot-options.txt.
> > +configuring fake nodes, see Documentation/x86/x86_64/boot-options.txt.
> >  
> >  For the purposes of this introduction, we'll assume a very primitive NUMA
> >  emulation setup of "numa=fake=4*512,".  This will split our system memory into
> > 
> > 
> > ---
> > 
> > On Fri, Oct 03, 2008 at 10:30:33AM -0700, Randy.Dunlap wrote:
> > > On Fri, 3 Oct 2008, Uwe Hermann wrote:
> > > 
> > > > The Documentation/i386 and Documentation/x86_64 directories and their
> > > > contents have been moved into Documentation/x86. Fix references to
> > > > those files accordingly.
> > > > 
> > > > Signed-off-by: Uwe Hermann <uwe@hermann-uwe.de>
> > > > 
> > > > diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
> > > > index b0c7b6c..1b1512f 100644
> > > > --- a/Documentation/x86/x86_64/boot-options.txt
> > > > +++ b/Documentation/x86/x86_64/boot-options.txt
> > > > @@ -143,7 +143,7 @@ Non Executable Mappings
> > > >  SMP
> > > >  
> > > >    additional_cpus=NUM Allow NUM more CPUs for hotplug
> > > > -		 (defaults are specified by the BIOS, see Documentation/x86_64/cpu-hotplug-spec)
> > > > +		 (defaults are specified by the BIOS, see Documentation/x86/x86_64/cpu-hotplug-spec)
> > > 
> > > This file needs one more line patched.  It still contains this:
> > > 
> > >    pirq=...	 See Documentation/i386/IO-APIC.txt
> > > 
> > > so change that one also and then you can add
> > >   Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> > > to it if you want to.
> > 
> > Done, thanks. Updated patch above.
> > 
> > 
> > Uwe.
> > -- 

-- 
~Randy
