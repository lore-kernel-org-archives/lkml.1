Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbYACQMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbYACQMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYACQMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:12:10 -0500
Received: from outbound-mail-28.bluehost.com ([69.89.17.198]:40921 "HELO
	outbound-mail-28.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751897AbYACQMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:12:09 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2008 11:12:09 EST
MIME-Version: 1.0
Date: Thu, 3 Jan 2008 09:05:28 -0700
From: Bernd Prager <bernd@prager.ws>
To: linux-kernel@vger.kernel.org
Subject: kernel config for AMD Athlon 64 X2 4200+ Manchester
Message-ID: <bb078b9bc5a6138dc7ac78609713efdd@prager.ws>
User-Agent: RoundCube Webmail/0.1-rc1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Identified-User: {1020:box307.bluehost.com:pragerws:prager.ws} {sentby:smtp auth 69.89.31.107 authed with bernd@prager.ws}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am running kernel 2.6.23.12 and compiled with SMP on.
Unfortunately the kernel doesn't recognize my dual core processor:

$ dmesg | grep -i cpu
CPU has 2 num_cores
Processor #0 (Bootup-CPU)
SMP: Allowing 1 CPUs, 0 hotplug CPUs
PERCPU: Allocating 34344 bytes of per cpu data
Initializing CPU#0
CPU 0: aperture @ 610000000 size 32 MB
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
Brought up 1 CPUs

$  cat /proc/cpuinfo 
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 43
model name      : AMD Hammer Family processor - Model Unknown
stepping        : 1
cpu MHz         : 2211.347
cache size      : 512 KB
physical id     : 0
siblings        : 1
core id         : 0
cpu cores       : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt lm
3dnowext 3dnow up rep_good pni lahf_lm
bogomips        : 4425.39
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp


Any ideas how I can configure the kernel to fix that?

Thanks for any help,
-- Bernd Prager


