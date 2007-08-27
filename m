Return-Path: <linux-kernel-owner+w=401wt.eu-S1760328AbXH0SDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328AbXH0SDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 14:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758646AbXH0SDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 14:03:17 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:56235 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758379AbXH0SDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 14:03:16 -0400
Subject: Re: nmi_watchdog=2 regression in 2.6.21
From: Daniel Walker <dwalker@mvista.com>
To: eranian@hpl.hp.com
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>, ak@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20070827175431.GD784@frankl.hpl.hp.com>
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <20070808142059.GF30805@atjola.homenet>
	 <20070827175431.GD784@frankl.hpl.hp.com>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 10:55:31 -0700
Message-Id: <1188237331.2435.255.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 10:54 -0700, Stephane Eranian wrote:
> Daniel,
> 
> You mentioned you have a development board with a dual Pentium-M.
> 
> What are the exact family/model numbers?
> 
> What Bjorn points you at below is a fix that applies to
> Intel Core Duo/Solo (Yonah) and Intel Core 2 series but not to
> regular Pentium-M (no architectural perfmon there).
> 
> I have successfully booted 2.6.23-rc3 on PIII, Opteron and Intel Core 2
> Duo with nmi_watchdog=2.

Here is the cpuinfo for processor 0 .. It's got four cores so this isn't
the full /proc/cpuinfo output ..

processor       : 0
vendor_id       : GenuineIntel 
cpu family      : 6
model           : 14
model name      : Intel(R) Dual Pentium(R) M CPU        @ 2.00GHz
stepping        : 8
cpu MHz         : 1992.000
cache size      : 2048 KB
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
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss htr
bogomips        : 4002.48
clflush size    : 64



