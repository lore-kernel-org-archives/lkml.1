Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbXKDTjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbXKDTjI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 14:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbXKDTi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 14:38:56 -0500
Received: from aun.it.uu.se ([130.238.12.36]:53957 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbXKDTi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 14:38:56 -0500
Date: Sun, 4 Nov 2007 20:38:33 +0100 (MET)
Message-Id: <200711041938.lA4JcXGk013845@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: hpa@zytor.com, mikpe@it.uu.se
Subject: Re: [PATCH] fix i486 boot failure due to stale %ds
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Nov 2007 10:29:34 -0800, H. Peter Anvin wrote:
>Could you send me your /proc/cpuinfo?

Sure. It's a 100Mhz Intel 486 DX4:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 4
model		: 8
model name	: 486 DX/4
stepping	: 0
cache size	: 0 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme
bogomips	: 49.66
clflush size	: 32

>Also, I would be very interested if you could try out this patch:
...
>Urk, -ENOTAWAKEYET.  Try *THIS* patch, please.

First patch didn't build. Second patch builds and boots Ok.

So this means the 486 DX4 has a buggy mov to %cr0?

/Mikael
