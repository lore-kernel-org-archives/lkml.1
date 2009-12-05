Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbZLEOVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbZLEOVZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 09:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbZLEOVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 09:21:24 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:55674 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbZLEOVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 09:21:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=CQlayZpz+TP7eWOQPKlwkAuBtREcIiEX66538QLYn9tKZUKdvR8lZN1oVXxCoCGgSs
         rkjX8SGXNWi1clh84aw6CqB8Vn5AXW5+2fY8oneL3gVeDh/lOQjSwzhN3/cxp4lC7a4t
         8IDmKrxTrsFt+pbCK1ozWEQY1Ua8/KX3qSoEg=
Message-ID: <4B1A6C64.4050408@gmail.com>
Date: Sat, 05 Dec 2009 15:21:24 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091122 SUSE/3.0.0-4.1 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: linux-next: manual merge of the limits tree with the net and
 fsnotify trees
References: <20091204183011.e92d36cd.sfr@canb.auug.org.au>	<4B18C15A.8060901@gmail.com> <20091205150053.48384393.sfr@canb.auug.org.au>
In-Reply-To: <20091205150053.48384393.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2009 05:00 AM, Stephen Rothwell wrote:
> On Fri, 04 Dec 2009 08:59:22 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:
>>
>> On 12/04/2009 08:30 AM, Stephen Rothwell wrote:
>>> diff --cc arch/x86/ia32/ia32entry.S
>>> index da89ae1,c61ced2..0000000
>>> --- a/arch/x86/ia32/ia32entry.S
>>> +++ b/arch/x86/ia32/ia32entry.S
>>> @@@ -841,7 -841,6 +841,9 @@@ ia32_sys_call_table
>>>   	.quad compat_sys_pwritev
>>>   	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
>>>   	.quad sys_perf_event_open
>>>  +	.quad compat_sys_recvmmsg
>>>  +	.quad sys_fanotify_init
>>>  +	.quad sys32_fanotify_mark
>>> + 	.quad compat_sys_getprlimit
>>
>> Thanks, but please go on with the by-five numbering in comments.
> 
> I am sure that will be done by whoever does the final conflict
> resolution.

Ah, sorry, I apparently don't know how this works. Thanks for explanation.

-- 
js
