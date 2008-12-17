Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753267AbYLQXZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbYLQXZ6 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYLQXZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:25:48 -0500
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:23029 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYLQXZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:25:48 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Dec 2008 18:25:47 EST
Date: Thu, 18 Dec 2008 00:20:44 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: FPU emulation broken in 2.6.28-rc8 ?
In-Reply-To: <20081217225221.GA6247@bitwizard.nl>
Message-ID: <alpine.LNX.2.00.0812180017480.10083@swampdragon.chaosbits.net>
References: <20081217085620.GA20184@bitwizard.nl> <20081217203227.GA10899@bitwizard.nl> <878wqe1kvg.fsf@basil.nowhere.org> <20081217225221.GA6247@bitwizard.nl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008, Rogier Wolff wrote:

> On Wed, Dec 17, 2008 at 11:45:39PM +0100, Andi Kleen wrote:
> > Rogier Wolff <R.E.Wolff@BitWizard.nl> writes:
> > >> 
> > >> I'm trying to set up a thin client, which runs on a geode, which
> > >> apparently doesn't have a FPU.... (/proc/cpuinfo mentions the flag 
> > >> "fpu", what does THAT mean?)
> > 
> > Geodes all have FPUs to my knowledge.
> > The only FPU less x87s are 386s and special 486s (and a few emulators)
> > 
> > If the FPU doesn't work on the Geode something else must be broken
> > (or your CPU is not really a Geode)
> 
> Although the /proc/cpuinfo file shows the FPU flag, the kernel stops
> with "no fpu found, and math emulation not present" if I disable
> FP emulation.... 
> 
> chipolata:/etc/X11# cat /proc/cpuinfo 
> processor       : 0
> vendor_id       : CyrixInstead
> cpu family      : 5
> model           : 9
> model name      : Geode(TM) Integrated Processor by National Semi
> stepping        : 2
> cpu MHz         : 299.913
> cache size      : 16 KB
> fdiv_bug        : yes
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : no
> fpu_exception   : no
> cpuid level     : 2
> wp              : yes
> flags           : fpu tsc msr cx8 cmov mmx cxmmx
> bogomips        : 599.82
> clflush size    : 32
> power management:
> 
I've got a box with a Geode CPU here (although a slightly newer one than 
yours) and it works fine without FPU/math emulation.

root@swampdragon:~# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 5
model           : 10
model name      : Geode(TM) Integrated Processor by AMD PCS
stepping        : 2
cpu MHz         : 499.894
cache size      : 128 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu de pse tsc msr cx8 sep pge cmov clflush mmx mmxext 3dnowext 3dnow up
bogomips        : 999.78
clflush size    : 32
power management:

