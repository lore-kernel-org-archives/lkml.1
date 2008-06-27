Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbYF0Rh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbYF0Rh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbYF0Rhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:37:50 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:35380 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbYF0Rht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:37:49 -0400
Date: Fri, 27 Jun 2008 10:36:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Chris Friesen <cfriesen@nortel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip/master] x86: nmi_watchdog - documentation fix
Message-Id: <20080627103655.6c6943e9.randy.dunlap@oracle.com>
In-Reply-To: <20080627171836.GF18957@cvg>
References: <20080627154340.GC18957@cvg>
	<Pine.LNX.4.55.0806271652020.8868@cliff.in.clinika.pl>
	<20080627165937.2f1fb661@lxorguk.ukuu.org.uk>
	<4865160C.2040403@nortel.com>
	<20080627165125.GE18957@cvg>
	<20080627095608.649e819a.randy.dunlap@oracle.com>
	<20080627171836.GF18957@cvg>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 21:18:36 +0400 Cyrill Gorcunov wrote:

> [Randy Dunlap - Fri, Jun 27, 2008 at 09:56:08AM -0700]
> | On Fri, 27 Jun 2008 20:51:25 +0400 Cyrill Gorcunov wrote:
> | 
> | > [Chris Friesen - Fri, Jun 27, 2008 at 10:32:12AM -0600]
> | > > Alan Cox wrote:
> | > >> On Fri, 27 Jun 2008 16:54:19 +0100 (BST)
> | > >> "Maciej W. Rozycki" <macro@linux-mips.org> wrote:
> | > >>> On Fri, 27 Jun 2008, Cyrill Gorcunov wrote:
> | > >>>
> | > >>>
> | > >>>> +NOTE: Prior to 2.4.2-ac18 the NMI-oopser is enabled unconditionally
> | > >>>> +on x86 SMP boxes.
> | > >>>
> | > >>> While you are at it: s/is/was/.
> | > >> Erm - why ??
> | > >> It is still true today that kernels < 2.4.2-ac8 have the NMI oopser
> | > >> enabled.
> | > >
> | > > To my ear the phrase as written implies past tense for the author/reader 
> | > > (i.e. "at points in time prior to the release of 2.4.2-ac18"), and thus 
> | > > grates against "is".
> | > >
> | > > The following sounds better to me: "In kernels prior to 2.4.2-ac18 the 
> | > > NMI-oopser is enabled..."  In this context the phrase itself is in the 
> | > > present, but we point to past kernels.
> | > >
> | > > Chris
> | > >
> | > 
> | > And the winner is? I'm not native English speaker so I can't select
> | > a better candidate in {is,was} limited set.
> | 
> | Use the text that Chris suggested...
> | 
> | 
> | ---
> | ~Randy
> | Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
> | http://linuxplumbersconf.org/
> | 
> 
> Ok, you choose ;)
> 
> 		- Cyrill -

Looks good to me.  Thanks for persisting.


> ---
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> Subject: [PATCH -tip/master] x86: nmi_watchdog - documentation fix
> 
> mi_watchdog is set to NMI_NONE by default (ie disabled) on _any_
> mode so lets fix documentation too.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> CC: Maciej W. Rozycki <macro@linux-mips.org>
> ---
> 
> Index: linux-2.6.git/Documentation/nmi_watchdog.txt
> ====================================================================
> --- linux-2.6.git.orig/Documentation/nmi_watchdog.txt	2008-06-27 19:50:06.000000000 +0400
> +++ linux-2.6.git/Documentation/nmi_watchdog.txt	2008-06-27 21:15:02.000000000 +0400
> @@ -10,7 +10,7 @@ us to generate 'watchdog NMI interrupts'
>  which get executed even if the system is otherwise locked up hard).
>  This can be used to debug hard kernel lockups.  By executing periodic
>  NMI interrupts, the kernel can monitor whether any CPU has locked up,
> -and print out debugging messages if so.  
> +and print out debugging messages if so.
>  
>  In order to use the NMI watchdog, you need to have APIC support in your
>  kernel. For SMP kernels, APIC support gets compiled in automatically. For
> @@ -22,8 +22,7 @@ CONFIG_X86_UP_IOAPIC is for uniprocessor
>  kernel debugging options, such as Kernel Stack Meter or Kernel Tracer,
>  may implicitly disable the NMI watchdog.]
>  
> -For x86-64, the needed APIC is always compiled in, and the NMI watchdog is
> -always enabled with I/O-APIC mode (nmi_watchdog=1).
> +For x86-64, the needed APIC is always compiled in.
>  
>  Using local APIC (nmi_watchdog=2) needs the first performance register, so
>  you can't use it for other purposes (such as high precision performance
> @@ -63,16 +62,15 @@ when the system is idle), but if your sy
>  "hlt", then you are out of luck -- the event will not happen at all and the
>  watchdog won't trigger. This is a shortcoming of the local APIC watchdog
>  -- unfortunately there is no "clock ticks" event that would work all the
> -time. The I/O APIC watchdog is driven externally and has no such shortcoming.  
> +time. The I/O APIC watchdog is driven externally and has no such shortcoming.
>  But its NMI frequency is much higher, resulting in a more significant hit
>  to the overall system performance.
>  
> -NOTE: starting with 2.4.2-ac18 the NMI-oopser is disabled by default,
> -you have to enable it with a boot time parameter.  Prior to 2.4.2-ac18
> -the NMI-oopser is enabled unconditionally on x86 SMP boxes.
> +On x86 nmi_watchdog is disabled by default so you have to enable it with
> +a boot time parameter.
>  
> -On x86-64 the NMI oopser is on by default. On 64bit Intel CPUs
> -it uses IO-APIC by default and on AMD it uses local APIC.
> +NOTE: In kernels prior to 2.4.2-ac18 the NMI-oopser is enabled unconditionally
> +on x86 SMP boxes.
>  
>  [ feel free to send bug reports, suggestions and patches to
>    Ingo Molnar <mingo@redhat.com> or the Linux SMP mailing
> --

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
