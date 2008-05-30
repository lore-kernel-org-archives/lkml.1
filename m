Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbYE3R3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbYE3R3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 13:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYE3R3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 13:29:24 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:47433
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754267AbYE3R3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 13:29:23 -0400
Message-Id: <E8739999-A8AE-4C10-AF7A-43387DBD8B10@it-loops.com>
From: Guntsche Michael <mike@it-loops.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v924)
Subject: Fwd: 2.6.25.x: Wrong CPU frequency (cpufreq table) with p4-clockmod
Date: Fri, 30 May 2008 19:29:20 +0200
References: <22164834-E7AA-4161-916C-F3D95E3BEA10@it-loops.com>
X-Mailer: Apple Mail (2.924)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now to the correct list.

> From: Guntsche Michael <mike@it-loops.com>
> Date: May 30, 2008 19:21:14 GMT+02:00
> To: Arjan van de Ven <arjan@infradead.org>
> Cc: linux-raid@vger.kernel.org
> Subject: Re: 2.6.25.x: Wrong CPU frequency (cpufreq table) with p4- 
> clockmod
>
> Ok,
>
> I enabled debugging and here is the output of the boot-up
>
> cpufreq-core: trying to register driver p4-clockmod
> cpufreq-core: adding CPU 0
> p4-clockmod: has errata -- disabling low frequencies
> speedstep-lib: x86: f, model: 1
> speedstep-lib: P4 - MSR_EBC_FREQUENCY_ID: 0x8a01fe00 0x0
> speedstep-lib: P4 - FSB 100000 kHz; Multiplier 138; Speed 13800000 kHz
> freq-table: setting show_table for cpu 0 to e2950d60
> freq-table: table entry 0 is invalid, skipping
> freq-table: table entry 1 is invalid, skipping
> freq-table: table entry 2: 3450000 kHz, 2 index
> freq-table: table entry 3: 5175000 kHz, 3 index
> freq-table: table entry 4: 6900000 kHz, 4 index
> freq-table: table entry 5: 8625000 kHz, 5 index
> freq-table: table entry 6: 10350000 kHz, 6 index
> freq-table: table entry 7: 12075000 kHz, 7 index
> freq-table: table entry 8: 13800000 kHz, 8 index
> cpufreq-core: setting new policy for CPU 0: 3450000 - 13800000 kHz
> freq-table: request for verification of policy (3450000 - 13800000  
> kHz) for cpu 0
> freq-table: verification lead to (3450000 - 13800000 kHz) for cpu 0
> freq-table: request for verification of policy (3450000 - 13800000  
> kHz) for cpu 0
> freq-table: verification lead to (3450000 - 13800000 kHz) for cpu 0
> cpufreq-core: new min and max freqs are 3450000 - 13800000 kHz
> cpufreq-core: governor switch
> cpufreq-core: __cpufreq_governor for CPU 0, event 1
> cpufreq-core: governor: change or update limits
> cpufreq-core: __cpufreq_governor for CPU 0, event 3
> cpufreq-core: initialization complete
> cpufreq-core: driver p4-clockmod up and running
> p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
>
> FSB and the multiplier look a litte bit off to me.
>
> /Michael
>

