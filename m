Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753138AbYLQWwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbYLQWwd (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 17:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYLQWwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 17:52:24 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:57277 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752041AbYLQWwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 17:52:23 -0500
Date: Wed, 17 Dec 2008 23:52:21 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: FPU emulation broken in 2.6.28-rc8 ?
Message-ID: <20081217225221.GA6247@bitwizard.nl>
References: <20081217085620.GA20184@bitwizard.nl> <20081217203227.GA10899@bitwizard.nl> <878wqe1kvg.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878wqe1kvg.fsf@basil.nowhere.org>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 11:45:39PM +0100, Andi Kleen wrote:
> Rogier Wolff <R.E.Wolff@BitWizard.nl> writes:
> >> 
> >> I'm trying to set up a thin client, which runs on a geode, which
> >> apparently doesn't have a FPU.... (/proc/cpuinfo mentions the flag 
> >> "fpu", what does THAT mean?)
> 
> Geodes all have FPUs to my knowledge.
> The only FPU less x87s are 386s and special 486s (and a few emulators)
> 
> If the FPU doesn't work on the Geode something else must be broken
> (or your CPU is not really a Geode)

Although the /proc/cpuinfo file shows the FPU flag, the kernel stops
with "no fpu found, and math emulation not present" if I disable
FP emulation.... 

chipolata:/etc/X11# cat /proc/cpuinfo 
processor       : 0
vendor_id       : CyrixInstead
cpu family      : 5
model           : 9
model name      : Geode(TM) Integrated Processor by National Semi
stepping        : 2
cpu MHz         : 299.913
cache size      : 16 KB
fdiv_bug        : yes
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : no
fpu_exception   : no
cpuid level     : 2
wp              : yes
flags           : fpu tsc msr cx8 cmov mmx cxmmx
bogomips        : 599.82
clflush size    : 32
power management:


	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
