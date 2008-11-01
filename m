Return-Path: <linux-kernel-owner+w=401wt.eu-S1752034AbYKAHqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbYKAHqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 03:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbYKAHqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 03:46:22 -0400
Received: from smtp.zeuux.org ([210.51.160.52]:59266 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbYKAHqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 03:46:21 -0400
Date: Sat, 1 Nov 2008 15:46:01 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: Pete Clements <clem@clem.clem-digital.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc2-git6 fails compile -- cpu/common.c
Message-ID: <20081101074601.GD6556@ubuntu>
References: <200811010250.mA12orqv005451@clem.clem-digital.net> <20081101073156.GC6556@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081101073156.GC6556@ubuntu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2008 at 03:31:56PM +0800, Jianjun Kong wrote:
>On Fri, Oct 31, 2008 at 10:50:53PM -0400, Pete Clements wrote:
>>Fyi
>>2.6.28-rc2-git fails compile, uniprocessor x86. (Missed git4 and git5.)
>>
>>  CC      arch/x86/kernel/cpu/common.o
>>arch/x86/kernel/cpu/common.c: In function 'cpu_init':
>>arch/x86/kernel/cpu/common.c:1141: error: 'boot_cpu_id' undeclared (first use in this function)
>>arch/x86/kernel/cpu/common.c:1141: error: (Each undeclared identifier is reported only once
>>arch/x86/kernel/cpu/common.c:1141: error: for each function it appears in.)
>>make[2]: *** [arch/x86/kernel/cpu/common.o] Error 1
>>make[1]: *** [arch/x86/kernel/cpu] Error 2
>>make: *** [arch/x86/kernel] Error 2
>
>'boot_cpu_id' only defined at this head file(include/linux/smp_32.h)
>

See  http://lkml.org/lkml/2008/10/30/531

	Jianjun
-- 
Jianjun Kong | Happy Hacking
HomePage: http://kongove.cn
Gtalk: kongjianjun@gmail.com
Hope is good thing, maybe the best of things, and no good thing ever dies.
