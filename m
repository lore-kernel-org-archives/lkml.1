Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbZAWFT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbZAWFT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 00:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbZAWFTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 00:19:50 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:41508 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZAWFTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 00:19:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lNWliLpkXaNnEt45A6wdJM1YTf/uNRBQH///qO4ChH3vE+Jy7x8MbC73R+wVGmg91t
         qLG9muhLsNlQOZkYRlexvnUXoXvCf3jWI0iUZysDW2wt4yR05SIg8GKWV7y7hr6JDpOQ
         /EVeIwVZBiIWt0glKGI5sf5e9+f6M0WYnaWOw=
MIME-Version: 1.0
In-Reply-To: <49794422.2080109@kernel.org>
References: <49763718.7010501@kernel.org>
	 <86802c440901201249v3c877a88ie8e5f3bbf6abb871@mail.gmail.com>
	 <49794422.2080109@kernel.org>
Date: Thu, 22 Jan 2009 21:19:48 -0800
X-Google-Sender-Auth: b257164f8a5884a3
Message-ID: <86802c440901222119h3462cd10s75ad4e630defc4e@mail.gmail.com>
Subject: Re: [Fwd: kernel panic when using disable_mtrr_trim [was: Re: memory 
	beyond4GB invisible to the system even though CONFIG_HIGHMEM64G=y]]
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 8:14 PM, Tejun Heo <tj@kernel.org> wrote:
> Yinghai Lu wrote:
>> On Tue, Jan 20, 2009 at 12:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> with the config
>>>
>>> current tip said:
>>>
>>>  RELOCS  arch/x86/boot/compressed/vmlinux.relocs
>>> WARNING: Absolute relocations present
>>> Offset     Info     Type     Sym.Value Sym.Name
>>> c14d2186 00920e01   R_386_32 c1514000  __per_cpu_load
>>>
>> and will casue system reboot after
>>
>> [    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
>> [    0.000000] PERCPU: Allocating 36864 bytes of per cpu dat
>
> Can you please try the current core/percpu branch?  I tried your
> config but the problem doesn't happen here.
>

the core/percpu is not merged into tip/master?

YH
