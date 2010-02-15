Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab0BOJVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 04:21:51 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:56756 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab0BOJVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 04:21:50 -0500
Message-ID: <4B79122A.9070102@shikadi.net>
Date: Mon, 15 Feb 2010 19:21:46 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.23) Gecko/20091130 Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: UML error - apps killed 50% of the time
References: <4B78EF9C.6040801@shikadi.net> <20100215090053.GG12076@hack.private>
In-Reply-To: <20100215090053.GG12076@hack.private>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> $ ls
>> Killed
>> $ ls
>> Killed
>>
>> vmlinux[6300] general protection eip:b7ea5124 esp:1785bdfc error:0
>>
>> Why doesn't UML work any more?
>
> http://patchwork.kernel.org/patch/79358/
>
> Does this patch help?

Sort of - ls doesn't get killed any more and I can get about half way through 
the boot process before things start getting killed (as opposed to them 
getting killed right away.)

Whatever this patch does, if it could do it twice as much then my problem 
would be solved ;-)

Thanks,
Adam.
