Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab0BUDAI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 22:00:08 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:40104 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab0BUDAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 22:00:05 -0500
Message-ID: <4B80A1B2.10207@shikadi.net>
Date: Sun, 21 Feb 2010 13:00:02 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.23) Gecko/20091130 Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: UML broken - runaway loop modprobe binfmt-464c
References: <4B78EE15.9020407@shikadi.net> <20100215113730.GL12076@hack.private> <20100215161111.GA18664@c2.user-mode-linux.org>
In-Reply-To: <20100215161111.GA18664@c2.user-mode-linux.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> So you are using 32-bit modprobe binary and 64-bit kernel?
>>
>> This will not work, since kernel binfmt_elf module checks
>> if e_machine is EM_X86_64.
>
> Not just 32-bit modprobe - any 32-bit binary on a 64-bit UML will
> cause this, I think.

Thanks for the suggestions.  After some more investigation and off-list 
pointers, it seems the problem is caused because compiling UML for x86_64 
doesn't allow you to enable IA32 emulation.

Is this just a case of the Kconfig option being missed, or is there a more 
fundamental reason as to why, unlike with the Linux kernel, it's not possible 
to run 32-bit apps inside a 64-bit UML?

Thanks,
Adam.
