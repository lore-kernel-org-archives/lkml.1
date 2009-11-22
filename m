Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZKVLzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZKVLzR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 06:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbZKVLzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 06:55:16 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:15488 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752726AbZKVLzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 06:55:15 -0500
Message-ID: <4B09269B.8070602@ru.mvista.com>
Date: Sun, 22 Nov 2009 14:55:07 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: wuzhangjin@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] MIPS: Add a high resolution sched_clock() via cnt32_to_63().
References: <dae45f23b5d34f64fc60a445015e7dfe05aa0d07.1258875717.git.wuzhangjin@gmail.com>	 <20091122081328.GB24558@elte.hu> <1258888086.4548.52.camel@falcon.domain.org>
In-Reply-To: <1258888086.4548.52.camel@falcon.domain.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Wu Zhangjin wrote:

>>> +static void __maybe_unused setup_sched_clock_update(unsigned long tclk)
>>> +{
>>> +	unsigned long data;
>>> +
>>> +	data = (0xffffffffUL / tclk / 2 - 2) * HZ;
>>>       
>
> Because the MIPS c0 count's frequency is half of the cpu frequency(Hi, Ralf, does every MIPS c0 count meet this feature?),

   No, e.g. Alchemy's C0 Count ticks at full CPU speed.

WBR, Sergei


