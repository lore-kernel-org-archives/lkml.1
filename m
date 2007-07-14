Return-Path: <linux-kernel-owner+w=401wt.eu-S1765692AbXGNWqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765692AbXGNWqJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 18:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbXGNWp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 18:45:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:65063 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXGNWp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 18:45:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:organization:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=nsWRVUczQBTvSQf+YQLjtEO4o/aKWdaemYM5AkdIRZKsrr1YF6BZZ4ULz45GsZgxDwr08Fy/aIidBzVQP0UwhC2OF9iaRPBQ2vSFYsyqWppQSwj7SH9jLzZYyiefpqKfb/64h8rhWcCtl8Eau0PpimgZC2nDFzFPaRUuUhrRQZs=
Message-ID: <4699521B.7030004@gmail.com>
Date: Sun, 15 Jul 2007 00:45:47 +0200
From: Patrizio Bassi <patrizio.bassi@gmail.com>
Reply-To: patrizio.bassi@gmail.com
Organization: patrizio.bassi@gmail.com
User-Agent: Thunderbird 2.0.0.4 (X11/20070619)
MIME-Version: 1.0
To: "Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: ACPI cpufreq broken on 2.6.22 for core2 duo
References: <8GYrv-5D7-19@gated-at.bofh.it>
In-Reply-To: <8GYrv-5D7-19@gated-at.bofh.it>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrizio Bassi ha scritto:
> With linux 2.6.21 and 22 i cannot get cpufreq working anymore while it
> worked in previous versions
> 
> ACPI Exception (processor_core-0781): AE_NOT_FOUND, Processor Device is
> not present [20070126]
> ACPI Exception (processor_core-0781): AE_NOT_FOUND, Processor Device is
> not present [20070126]
> 
> i'm in 64bit profile.
> Bios updated to latest version.
> 
> CC me as i'm not subscribed.
> 
> 
> cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
> stepping        : 6
> cpu MHz         : 1866.667
> cache size      : 2048 KB
> physical id     : 0
> siblings        : 2
> core id         : 0
> cpu cores       : 2
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall
> nx lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
> bogomips        : 3735.47
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
> stepping        : 6
> cpu MHz         : 1866.667
> cache size      : 2048 KB
> physical id     : 0
> siblings        : 2
> core id         : 1
> cpu cores       : 2
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall
> nx lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
> bogomips        : 3733.31
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 


Sorry, i posted it twice by error.
however i found same issue described here:

http://bugzilla.kernel.org/show_bug.cgi?id=8630

Sorry for bothering


Patrizio
