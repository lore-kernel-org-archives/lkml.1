Return-Path: <linux-kernel-owner+w=401wt.eu-S1764302AbXFEKNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764302AbXFEKNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 06:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763757AbXFEKNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 06:13:00 -0400
Received: from bravo.securenet-server.net ([207.210.84.244]:45544 "EHLO
	bravo.securenet-server.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763486AbXFEKM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 06:12:59 -0400
X-Greylist: delayed 1189 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jun 2007 06:12:59 EDT
From: Mircea Bardac <dev.list@mircea.bardac.net>
To: "Peter Oruba" <peter.oruba@amd.com>
Subject: Re: CPU off-on-off: lost CPU management?
Date: Tue, 5 Jun 2007 12:56:44 +0300
User-Agent: KMail/1.9.7
Cc: stefan.prechtel@googlemail.com,
       "Linux List" <linux-kernel@vger.kernel.org>
References: <200706051003.29501.peter.oruba@amd.com> <200706051253.01551.dev.list@mircea.bardac.net>
In-Reply-To: <200706051253.01551.dev.list@mircea.bardac.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706051256.49179.dev.list@mircea.bardac.net>
X-PopBeforeSMTPSenders: bmi@bardac.net
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bravo.securenet-server.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mircea.bardac.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 June 2007 12:52:59 Mircea Bardac wrote:
> Hi Peter,
>
> This time with Kernel 2.6.21.3.
>
> [...]
>
> # echo 1 > /sys/devices/system/cpu/cpu1/online
>
> # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 15
> model           : 72
> model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
> stepping        : 2
> cpu MHz         : 800.000
> cache size      : 512 KB
> physical id     : 0
> siblings        : 1
> core id         : 0
> cpu cores       : 1
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8legacy
> ts fid vid ttp tm stc
> bogomips        : 1597.67
> clflush size    : 64
>
> processor       : 1
> vendor_id       : AuthenticAMD
> cpu family      : 15
> model           : 72
> model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
> stepping        : 2
> cpu MHz         : 798.015
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8legacy
> ts fid vid ttp tm stc
> bogomips        : 1596.26
> clflush size    : 64


As a follow-up:

As Stefan noticed initially, the CPU frequency of the 2nd CPU is different 
after the CPU is brought back online.

Mircea
