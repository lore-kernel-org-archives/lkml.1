Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbXFZIS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbXFZIS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbXFZISR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:18:17 -0400
Received: from ihemail3.lucent.com ([135.245.0.37]:40279 "EHLO
	ihemail3.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbXFZISQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:18:16 -0400
Message-ID: <4680CBD4.2040702@alcatel-lucent.com>
Date: Tue, 26 Jun 2007 16:18:28 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: bugs in __schedule()
References: <4680C6F3.9000504@alcatel-lucent.com> <b6fcc0a0706260114o59b489a7o7dd7e4ce2e621852@mail.gmail.com>
In-Reply-To: <b6fcc0a0706260114o59b489a7o7dd7e4ce2e621852@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2007 08:18:10.0656 (UTC) FILETIME=[889C2600:01C7B7CA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The code is written by myself. 2 questions:

1) tasklet couldn't sleep?
2) It is because the tasklet take a semaphore?

Thanks,
Gavin

Alexey Dobriyan wrote:
> On 6/26/07, gshan <gshan@alcatel-lucent.com> wrote:
>> Anybody has suggestions on this crash?
>
> talk to whoever supplied the following into your kernel:
>
>> [c02dc4dc] __schedule+0x654/0x788
>>  [c02dc6f4] schedule+0x4c/0xe4
>>  [c02dbe24] __compat_down+0xc8/0x12c
>>  [c0226b60] mv_sw_read_reg+0x178/0x17c
>
> this
>
>>  [c02296fc] mvSwIntrTasklet+0x128/0x744
>
> and this.
>
>>  [c0020afc] tasklet_action+0x7c/0xec
>>  [c00204f4] ___do_softirq+0x80/0x11c
>>  [c00205cc] __do_softirq+0x3c/0x6c
>>  [c00206a4] do_softirq+0x60/0x68
>>  [c00207a8] irq_exit+0x6c/0x94
>>  [c0005e1c] do_IRQ+0x88/0xa4
>>  [c0004b70] ret_from_except+0x0/0x18
>>  [c000680c] __delay+0xc/0x14
>>  [c0226598] mv_sw_read_smi_reg+0x84/0x1ac

