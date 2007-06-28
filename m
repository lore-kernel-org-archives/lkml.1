Return-Path: <linux-kernel-owner+w=401wt.eu-S932475AbXF1Xh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbXF1Xh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbXF1Xhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:37:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:8138 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516AbXF1Xhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:37:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,472,1175497200"; 
   d="scan'208";a="262373008"
Date: Thu, 28 Jun 2007 16:33:13 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Wrong cache size reported on Q6600
Message-ID: <20070628233312.GB30594@linux-os.sc.intel.com>
References: <200706290931.45355.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706290931.45355.kernel@kolivas.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 09:31:44AM +1000, Con Kolivas wrote:
> This is a Q6600 which has cache size of 8 MB. Unless it's reporting each 
> half's effective L2, I think it should be reporting 8192 instead of 4096.

There are two L2's, each of 4MB. Each L2 shared by two cores.

thanks,
suresh

> 
> On 2.6.22-rc6:
> 
> cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz
> stepping        : 7
> cpu MHz         : 2401.919
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 4
> core id         : 0
> cpu cores       : 4
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm 
> constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
> bogomips        : 4806.38
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz
> stepping        : 7
> cpu MHz         : 2401.919
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 4
> core id         : 1
> cpu cores       : 4
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm 
> constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
> bogomips        : 4803.73
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> processor       : 2
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz
> stepping        : 7
> cpu MHz         : 2401.919
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 4
> core id         : 2
> cpu cores       : 4
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm 
> constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
> bogomips        : 4803.86
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> processor       : 3
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz
> stepping        : 7
> cpu MHz         : 2401.919
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 4
> core id         : 3
> cpu cores       : 4
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm 
> constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
> bogomips        : 4803.93
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> -- 
> -ck
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
