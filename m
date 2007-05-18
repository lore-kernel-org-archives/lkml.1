Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbXERG1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbXERG1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbXERG1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:27:23 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:35642 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbXERG1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:27:22 -0400
Date: Fri, 18 May 2007 08:24:35 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Simon Arlott <simon@fire.lp0.eu>
cc: Claas Langbehn <claas@rootdir.de>, LKML <linux-kernel@vger.kernel.org>,
       hpa@zytor.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: This kernel requires the following features not present on the
 CPU... (on a VIA C7 CPU)
In-Reply-To: <464CB726.6090201@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.61.0705180820210.3231@yvahk01.tjqt.qr>
References: <464C4A22.7040709@rootdir.de> <464CB726.6090201@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


since VIA seems to be one of the quirkier CPUs...

On May 17 2007 21:12, Simon Arlott wrote:
> On 17/05/07 13:27, Claas Langbehn wrote:
>>> Claas Langbehn wrote:

>>>> Would it be possible to override the BIOS settings of cx8 and nx and
>>>> activate it with linux anyway?
>>>> The CPU supports it and I don't see any reason to disable it.
>> 
>> Yes, that code is already in the git.newsetup tree.
>
> Is it automatic? I have CONFIG_X86_CMPXCHG=y without cx8 showing in cpuinfo,
> and it appears to work fine.
>
> Will your changes needlessly prevent the kernel running? Would I be right in
> thinking that the kernel is successfully using cmpxchg even though it's
> considered disabled? I realise people compile kernels for the wrong CPU but
> preventing them working when it's been chosen correctly seems wrong.
>
> processor       : 0
> vendor_id       : CentaurHauls
> cpu family      : 6
> model           : 10
> model name      : VIA Esther processor 1500MHz
> stepping        : 9
> cpu MHz         : 800.000 (cpufreq)
> cache size      : 128 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce apic sep mtrr pge cmov pat
> clflush acpi mmx fxsr sse sse2 tm nx pni est tm2 rng rng_en ace ace_en ace2
> ace2_en phe phe_en pmm pmm_en
> bogomips        : 1601.18
> clflush size    : 64

http://lkml.org/lkml/2007/5/5/134 , shows a Family-6 Model-*9* which
*does* have CX8 (with CONFIG_M586=y, CONFIG_X86_CMPXCHG=y,
CONFIG_X86_CMPXCHG64=y). Just a hint that you do not inadvertently
disable CX there ;-)


	Jan
-- 
