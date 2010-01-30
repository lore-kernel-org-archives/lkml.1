Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175Ab0A3MAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab0A3MAR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 07:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517Ab0A3MAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 07:00:16 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52452 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab0A3MAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 07:00:15 -0500
Message-ID: <4B641F4D.6090704@dcl.info.waseda.ac.jp>
Date: Sat, 30 Jan 2010 21:00:13 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 00/12] perf lock: New subcommand "perf lock", for	analyzing
 lock statistics
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100129143403.GJ13771@kernel.dk>
In-Reply-To: <20100129143403.GJ13771@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010年01月29日 23:34), Jens Axboe wrote:
> On Fri, Jan 22 2010, Hitoshi Mitake wrote:
>    
>> Adding new subcommand "perf lock" to perf.
>>
>> I made this patch series on
>> latest perf/core of tip (ef12a141306c90336a3a10d40213ecd98624d274),
>> so please apply this series to perf/core.
>>      
> [snip]
>
> I wanted to give this a go today, since I think it's pretty nifty and a
> lot better than using /proc/lock_stat. But it basically spirals the
> system into death [1]. How big a system did you test this on?
>
> [1] Got this: [  117.097918] hrtimer: interrupt took 35093901 ns
>
>    

I tested this on Core i7 965 + 3GB DRAM machine.
Test program is mainly "perf bench sched messaging".

Could you tell me the detail of your test situation?

Thanks,
Hitoshi

