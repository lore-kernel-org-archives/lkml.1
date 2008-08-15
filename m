Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbYHOOH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbYHOOH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYHOOHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:07:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58558 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbYHOOHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:07:16 -0400
Date: Fri, 15 Aug 2008 16:07:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, David Miller <davem@davemloft.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Message-ID: <20080815140702.GD14103@elte.hu>
References: <Pine.LNX.4.64.0808151830170.19924@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808151830170.19924@boston.corp.fedex.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Chua <jeff.chua.linux@gmail.com> wrote:

>>> Shall this be put back so that it'll show the message?
>>> -       if (def_to_bigsmp && apicid > 8) {
>>> -               printk(KERN_WARNING
>>> -                       "More than 8 CPUs detected - skipping them.\n"
>>> -                       "Use CONFIG_X86_GENERICARCH and 
> CONFIG_X86_BIGSMP.\n");
>>> -       }
>>
>> could you post the full dmesg? And the modified patch that you've tested
>> to both have 8 CPUs without bigsmp and which also shows the printk?
>>
>>        Ingo
>>
>
> Attached. cpu.8
>    CONFIG_X86_32=y
>    CONFIG_X86_PC=y
>    CONFIG_X86=y
>    CONFIG_NR_CPUS=8
>
> Attached. cpu.16
>    CONFIG_X86_32=y
>    CONFIG_X86_PC=y
>    CONFIG_X86=y
>    CONFIG_NR_CPUS=16
>
> Attached cpu.16.big
>    CONFIG_X86_32=y
>    CONFIG_X86=y
>    CONFIG_X86_GENERICARCH=y
>    CONFIG_X86_BIGSMP=y
>    # CONFIG_X86_PC is not set
>    CONFIG_NR_CPUS=16
>
> Attached cpu.16.nobig (same as cpu.16 except with modifed patch)
>    CONFIG_X86_32=y
>    CONFIG_X86_PC=y
>    CONFIG_X86=y
>    CONFIG_NR_CPUS=16
>
> Attached is the modified patch to make the warning appears. It's 
> Yinghai's patch modified to just display the error and continue to 
> boot.

thanks. To make sure it's all sorted out you might want to boot today's 
tip/master and check whether it just does the right thing by default. 
(it really should)

	Ingo
