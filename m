Return-Path: <linux-kernel-owner+w=401wt.eu-S1757670AbYEGBsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670AbYEGBsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbYEGBri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:47:38 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:53821 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbYEGBrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:47:37 -0400
Message-ID: <48210A71.1060409@keyaccess.nl>
Date: Wed, 07 May 2008 03:48:33 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.26, PAT and AMD family 6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day.

On 2.6.25 and below, my /proc/cpuinfo looks like:

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 7
model name      : AMD Duron(tm) Processor
stepping        : 1
cpu MHz         : 1312.969
cache size      : 64 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov 
pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow ts
bogomips        : 2628.68
clflush size    : 32

while on current mainline PAT and TS (Temperature Sensor) drop from the 
feature flags:

flags		: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pse36 mmx 
fxsr sse syscall mmxext 3dnowext 3dnow

With respect to PAT, I guess it's 9307cacad0dfe3749f00303125c6f7f0523e5616, 
"x86: pat cpu feature bit setting for known cpus" but what's this about?

Did my cpuinfo lie upto this point or shouldn't the flag be cleared? The 
commit message for that change is completely and totally unhelpful.

Rene.
