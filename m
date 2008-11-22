Return-Path: <linux-kernel-owner+w=401wt.eu-S1758485AbYKVWhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbYKVWhx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758977AbYKVWfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:35:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37851 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758712AbYKVWfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:35:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: processors core stuck in full throttle after waking up from s2ram
Date: Sat, 22 Nov 2008 23:33:06 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1227168699.4276.24.camel@LiNuX> <200811222151.49273.rjw@sisk.pl> <1227389306.3171.14.camel@LiNuX>
In-Reply-To: <1227389306.3171.14.camel@LiNuX>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811222333.06459.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 22 of November 2008, Justin P. Mattock wrote:
> On Sat, 2008-11-22 at 21:51 +0100, Rafael J. Wysocki wrote:
> > On Thursday, 20 of November 2008, Justin P. Mattock wrote:
> > > (before getting into this I need to see if somebody else with a macbook
> > > pro(ATI with radeon drivers) is experiencing the same issue?)
> > > I'm not sure I this is caused by the kernel or the program s2ram.
> > > when I cat watch /proc/cpuinfo I see: (after waking up from suspend.)
> > > 
> > > Every 2.0s: cat /proc/cpuinfo
> > > Wed Nov 19 23:49:13 2008
> > > 
> > > processor       : 0
> > > vendor_id       : GenuineIntel
> > > cpu family      : 6
> > > model           : 15
> > > model name      : Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
> > > stepping        : 6
> > > cpu MHz         : 2167.000  
> > > cache size      : 4096 KB
> > > physical id     : 0
> > > siblings        : 2
> > > core id         : 0
> > > cpu cores       : 2
> > > apicid          : 0
> > > initial apicid  : 0
> > > fdiv_bug        : no
> > > hlt_bug         : no
> > > f00f_bug        : no
> > > coma_bug        : no
> > > fpu             : yes
> > > fpu_exception   : yes
> > > cpuid level     : 10
> > > wp              : yes
> > > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> > > mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
> > > constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx
> > >  est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
> > > bogomips        : 4322.49
> > > clflush size    : 64
> > > power management:
> > > 
> > > processor       : 1
> > > vendor_id       : GenuineIntel
> > > cpu family      : 6
> > > model           : 15
> > > model name      : Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
> > > stepping        : 6
> > > cpu MHz         : 1000.000
> > > cache size      : 4096 KB
> > > physical id     : 0
> > > siblings        : 2
> > > core id         : 1
> > > cpu cores       : 2
> > > apicid          : 1
> > > initial apicid  : 1
> > > fdiv_bug        : no
> > > hlt_bug         : no
> > > f00f_bug        : no
> > > coma_bug        : no
> > > fpu             : yes
> > > fpu_exception   : yes
> > > cpuid level     : 10
> > > wp              : yes
> > > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> > > mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
> > > constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx
> > >  est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
> > > bogomips        : 4322.60
> > > clflush size    : 64
> > > power management:
> > > 
> > > 
> > > the processor is full throttle on one of the cores.
> > 
> > Surely not.  The first core shows 2.16 GHz.
> > 
> > Anyway, it certainly is not related to the s2ram program in any way.
> 
> Normally I would see cpu MHz: 1000 under both entries,
> this time upon wakeup theres 1000 and 2167.00. the 2167.00 doesn't move
> down to 1000 i.g. example of system normally:
>  cat /proc/cpuinfo <below>
> 
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
> stepping        : 6
> cpu MHz         : 1000.000   
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 2
> core id         : 0
> cpu cores       : 2
> apicid          : 0
> initial apicid  : 0
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
> constant_tsc arch_perfmon                             pebs bts pni
> dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm
> tpr_shadow
> bogomips        : 4322.48
> clflush size    : 64
> power management:
> 
> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
> stepping        : 6
> cpu MHz         : 1000.000
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 2
> core id         : 1
> cpu cores       : 2
> apicid          : 1
> initial apicid  : 1
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
> constant_tsc arch_perfmon                             pebs bts pni
> dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm
> tpr_shadow
> bogomips        : 4322.51
> clflush size    : 64
> power management:
> 
> under normal use this 
> will move between 2167.00 to 1000 simultaneously under load with both
> cores, but then back down to 1000, for both when settled down.
> in this situation as I reported, the 2167.00 just
> stays at that number for one of the cores(if thats what I'm seeing) when
> waking up from suspend for some reason or another. 

Ah, ok.  So the problem is that core remains at the highest frequency.

What cpufreq driver is used on this box?

Rafael
