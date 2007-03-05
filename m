Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbXCEC56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbXCEC56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbXCEC56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 21:57:58 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:46212 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608AbXCEC55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 21:57:57 -0500
Message-ID: <45EB8734.1030105@vmware.com>
Date: Sun, 04 Mar 2007 18:57:56 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] remove arch/i386/kernel/tsc.c:custom_sched_clock
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <20070305014735.GP3441@stusta.de>
In-Reply-To: <20070305014735.GP3441@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
>   
>> ...
>> Changes since 2.6.20-mm2:
>> ...
>> +vmi-sched-clock-paravirt-op-fix.patch
>> ...
>>  2.6.21 queue
>> ...
>>     
>
> This patch removes the no longer used custom_sched_clock.
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>
> ---
> --- linux-2.6.21-rc2-mm1/arch/i386/kernel/tsc.c.old	2007-03-04 19:02:54.000000000 +0100
> +++ linux-2.6.21-rc2-mm1/arch/i386/kernel/tsc.c	2007-03-04 19:03:00.000000000 +0100
> @@ -24,7 +24,6 @@
>   * an extra value to store the TSC freq
>   */
>  unsigned int tsc_khz;
> -unsigned long long (*custom_sched_clock)(void);
>  
>  int tsc_disable;
>   

Acked-by: Zachary Amsden <zach@vmware.com>
