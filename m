Return-Path: <linux-kernel-owner+w=401wt.eu-S1751745AbZLRI7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbZLRI7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 03:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbZLRI7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 03:59:23 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:60886 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZLRI7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 03:59:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fsxDe355kFPvjCokkyUlOWBbCpoGjyhyPAOCAX0PU52RaQUu0EP5sA6/cqfMnyF9QF
         L9Q72Cx5K87/bHPEd9KWec82VOqeEcA1SgJEdlSb9RXRdfT7ItnkZrOVnJ2kK3IpeQ/c
         00x/oZJfQfRW026b+83ZvviQMqF4UNqTzQR2U=
Message-ID: <4B2B44E0.9000704@gmail.com>
Date: Fri, 18 Dec 2009 17:01:20 +0800
From: "Helight.Xu" <helight.xu@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [x86]compile error
References: <4B2B3EAF.2040302@gmail.com> <2375c9f90912180044x64620edex532bba96952882dd@mail.gmail.com>
In-Reply-To: <2375c9f90912180044x64620edex532bba96952882dd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> On Fri, Dec 18, 2009 at 4:34 PM, Helight.Xu <helight.xu@gmail.com> wrote:
>   
>> linux@linux-desktop:~/linux-2.6$ make modules
>>  CHK     include/linux/version.h
>>  CHK     include/linux/utsrelease.h
>>  SYMLINK include/asm -> include/asm-x86
>>  CALL    scripts/checksyscalls.sh
>>  Building modules, stage 2.
>>  MODPOST 1834 modules
>> ERROR: "snd_card_create" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
>> ERROR: "snd_ctl_notify" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
>> ERROR: "snd_ctl_boolean_mono_info" [drivers/platform/x86/thinkpad_acpi.ko]
>> undefined!
>> ERROR: "snd_ctl_new1" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
>> ERROR: "snd_card_free" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
>> ERROR: "snd_card_register" [drivers/platform/x86/thinkpad_acpi.ko]
>> undefined!
>> ERROR: "snd_ctl_add" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
>>     
>
> Does attached patch fix your problem?
>   
yes！it does work, I think you fix the problem!

-- 
Zhenwen Xu - Seven Helight
Home Page: http://zhwen.org

