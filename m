Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab0CKKyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:54:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:14424 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033Ab0CKKyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 05:54:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lY+ggT50El8TfOCfGS+Q389OWtrNTviS/sAWfNPRP0hu9X5H7CltokJr7FRa5Ea2gx
         13XKvyVyIFF2PCJEMkdVr9SmhxeYZnTnUpO+YsUtbw9eJl7y+hKk7eARJdVYKreIxshR
         T0Ea1l10xMAIToDVxYd5tf/1RgLH/DSN61zuA=
Message-ID: <4B98CBC8.6080008@gmail.com>
Date: Thu, 11 Mar 2010 11:54:00 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-5.1 Thunderbird/3.1b1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, cl@linux-foundation.com
Subject: Re: mmotm boot panic bootmem-avoid-dma32-zone-by-default.patch
References: <49b004811003041321g2567bac8yb73235be32a27e7c@mail.gmail.com> <20100305032106.GA12065@cmpxchg.org> <4B90C921.6060908@kernel.org> <4B90DC3C.1060000@gmail.com> <4B92FE9E.90600@kernel.org>
In-Reply-To: <4B92FE9E.90600@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2010 02:17 AM, Yinghai Lu wrote:
> On 03/05/2010 02:26 AM, Jiri Slaby wrote:
>> On 03/05/2010 10:04 AM, Yinghai Lu wrote:
>>> according to context
>>> http://patchwork.kernel.org/patch/73893/
>>>
>>> Jiri,
>>> please check current linus tree still have problem about mem_map is using that much low mem?
>>
>> Hi!
>>
>> Sorry, I don't have direct access to the machine. I might try to ask the
>> owners to do so.
>>
>>> on my 1024g system first node has 128G ram, [2g, 4g) are mmio range.
>>
>> So where gets your mem_map allocated (I suppose you're running flat model)?
>
> what kernel version? 2.6.27?

Hi, yes, it is 2.6.27.

> x86 64bit now only support SPARSEMEM.


-- 
js
