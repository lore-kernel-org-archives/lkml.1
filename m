Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbYGaO1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbYGaO1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYGaO1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:27:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:30192 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYGaO1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:27:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PijMHaSIoDlsij+98MzYXBx3h/xKQzBVOv08mx74HfPLdSVL10dZXVJjdW+zOlAE8k
         ptqfwd6Sfb3M39mo0OVgD86HHILGQ1TmT7H9Y1b9n9UrF3QmHriJJuWzHsXl5VGMsW04
         sRovg4jei8X/1VfHYIrWJrp7iWILTCKoUaQ0A=
Message-ID: <c4e36d110807310727t6cf2c60pc83eabec0a207f2e@mail.gmail.com>
Date: Thu, 31 Jul 2008 16:27:32 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Sysrq+B doesn't work on my box
In-Reply-To: <20080731135058.GA31888@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110807310645n3ff6e61j17414433c5aee030@mail.gmail.com>
	 <20080731135058.GA31888@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/31 Alexey Dobriyan <adobriyan@gmail.com>:
> On Thu, Jul 31, 2008 at 03:45:24PM +0200, Zdenek Kabelac wrote:
>> Hi
>>
>> I'd like to get resolved this problem - my T61 machine doesn't reboot
>> with SysRQ+B key.
>> And I never remember if it was ever rebooting.
>>
>> This is all I know so far and I've no idea where could be the problem.
>>
>> System is running Fedora rawhide 64bit.
>>
>> If I press any other  SysRQ combination - it works - so things like
>> Sync, Umount, powerOff do work normally.
>> It's just Boot  which does not even get to the  __handle  routine
>> (I've added one extra simple debug prinkt
>> for this case)
>>
>> So - who/how/where could mask this key sequence from being delivered
>> to the sysrq driver?
>> (obviously I do not have any problems typing letter 'b' itself)
>>
>>
>>
>> Another issue is - that even with  'echo b >/proc/sysrq-triggers' my
>> machine doesn't reboot.
>
> Typo here? Do
>
>        /bin/echo b >/proc/sysrq-trigger
>
>

Really only a typo during mail writting - normally I use bash 'tab'
completion for this anyway.
(also - as I said - debug messages I've placed into
arch/x86/kernel/reboot.c are really printed - machine just doesn't
reboot for some reason)

Zdenek
