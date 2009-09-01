Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbZIAHdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbZIAHdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 03:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbZIAHdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 03:33:08 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:58190 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbZIAHdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 03:33:07 -0400
Date: Tue, 1 Sep 2009 10:33:08 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Tejun Heo <tj@kernel.org>
cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: boot panic after oops from sysfs_new_dirent
In-Reply-To: <4A9CCD92.4090909@kernel.org>
Message-ID: <Pine.SOC.4.64.0909011032350.10835@math.ut.ee>
References: <Pine.SOC.4.64.0908311646150.20934@math.ut.ee>
 <20090831.142215.111904849.davem@davemloft.net> <Pine.SOC.4.64.0909011003460.10184@math.ut.ee>
 <4A9CC9E9.2070609@kernel.org> <4A9CCD92.4090909@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ummm.... one more question.  Is cpu0 missing?  Can you please post the
> output of "cat /proc/cpuinfo"?

Yes, there's no CPU numbered 0, the numbers come from hardware slots on 
backplane.

cpu             : TI UltraSparc II  (BlackBird)
fpu             : UltraSparc II integrated FPU
pmu             : ultra12
prom            : OBP 3.2.29 2001/06/18 17:28
type            : sun4u
ncpus probed    : 6
ncpus active    : 6
D$ parity tl1   : 0
I$ parity tl1   : 0
Cpu6ClkTck      : 000000000ec82e00
Cpu7ClkTck      : 000000000ec82e00
Cpu10ClkTck     : 000000000ec82e00
Cpu11ClkTck     : 000000000ec82e00
Cpu14ClkTck     : 000000000ec82e00
Cpu15ClkTck     : 000000000ec82e00
MMU Type        : Spitfire
State:
CPU6:           online
CPU7:           online
CPU10:          online
CPU11:          online
CPU14:          online
CPU15:          online


-- 
Meelis Roos (mroos@linux.ee)
