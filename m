Return-Path: <linux-kernel-owner+w=401wt.eu-S1761284AbXK2JcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761284AbXK2JcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 04:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756655AbXK2Jb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 04:31:59 -0500
Received: from [222.73.24.84] ([222.73.24.84]:50020 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756209AbXK2Jb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 04:31:59 -0500
Message-ID: <474E8669.6060409@cn.fujitsu.com>
Date: Thu, 29 Nov 2007 17:29:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trivial@kernel.org
Subject: Re: [PATCH 6/6] tick: add a missing dot in prink
References: <474E6BD0.20103@cn.fujitsu.com> <E1IxfE8-0000Sr-9w@faramir.fjphome.nl>
In-Reply-To: <E1IxfE8-0000Sr-9w@faramir.fjphome.nl>
Content-Type: text/plain; charset=x-user-defined
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Li Zefan wrote:
>> Add a missing '.' in prink information.
>> -			printk(" no tick device\n");
>> +			printk(" no tick device.\n");
> 
> I wonder if that is correct. CodingStyle says:
>                 Chapter 13: Printing kernel messages
>    [...]
>    Kernel messages do not have to be terminated with a period.
> 
> I personally think that rule could be made a bit stricter as for example
> dmesg output currently looks fairly inconsistent with some messages
> terminated with a period while most messages are not and have been wondering
> if I should file patches to _remove_ periods.
> 
> Maybe the rule should be changed to:
>    Kernel messages should not be terminated with a period, unless a single
>    message contains multiple sentences.
> ?

But why a kernel message should not be terminated with a period? It does no harm
at all. And if the message is a complete sentence, it's grammatical correct to
terminated with a period.

I think CodingStyle just says an ending period is not mandatory. It does not
discourage the ending period.


