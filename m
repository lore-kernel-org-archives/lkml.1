Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbXLLUYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbXLLUYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbXLLUY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:24:29 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:48862 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbXLLUY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:24:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AQQq+LS+/jvO8FJp8JtaN5LMLt3+6/XUE4wi6E/ISmWeMNZN/xgAYEvPOnHLfRQD6jSg5TFMvVQ/bfcy50jDZOXAiBH2aZspJkbRIhuIx/dappF40IP5gOGvOAbTTT6QS1yv6CCTARNgY9NXiBZkXpq1nY6UToxM+28RO9uziKQ=
Message-ID: <19f34abd0712121224s3b71bb0yc86089afaac677a5@mail.gmail.com>
Date: Wed, 12 Dec 2007 21:24:27 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: [RESULTS] Port 0x80 I/O speed
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Chris Holvenstot" <cholvenstot@comcast.net>
In-Reply-To: <47603327.6070307@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47603327.6070307@keyaccess.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 12, 2007 8:14 PM, Rene Herman <rene.herman@gmail.com> wrote:
> Time varies between 0.54 microseconds and 2.50 microseconds, with most
> around 1.3/1.4 microseconds. Numbers 58, 59 and 60 (the ones at > 2 us) I
> dont completely trust since similar machines are among the fastest as well.

Hi.

Just want to say that I get up to 2.7 on my Acer Aspire 5720Z laptop.

cycles: out 3955, in 3679
cycles: out 3972, in 3683
cycles: out 3963, in 3692
cycles: out 3961, in 3663
cycles: out 3977, in 3679
cycles: out 3990, in 3675

The test program was run with the following frequency setup:

# cpufreq-info
cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
Report errors and bugs to linux@brodo.de, please.
analyzing CPU 0:
  driver: acpi-cpufreq
  CPUs which need to switch frequency at the same time: 0 1
  hardware limits: 800 MHz - 1.47 GHz
  available frequency steps: 1.47 GHz, 1.07 GHz, 800 MHz
  available cpufreq governors: ondemand, userspace, performance
  current policy: frequency should be within 800 MHz and 1.47 GHz.
                  The governor "performance" may decide which speed to use
                  within this range.
  current CPU frequency is 1.47 GHz (asserted by call to hardware).

# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Pentium(R) Dual  CPU  T2310  @ 1.46GHz
stepping        : 13
cpu MHz         : 1467.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl est tm2 ssse3
cx16 xtpr lahf_lm
bogomips        : 2930.06
clflush size    : 64


This seems to be higher than the #60 on your list. What makes my
machine (and a few of the others') special?


Vegard
