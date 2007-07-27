Return-Path: <linux-kernel-owner+w=401wt.eu-S938468AbXG0Xwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938468AbXG0Xwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765552AbXG0Xwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:52:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:7642 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760903AbXG0Xwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:52:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=H/viNBL/6VVbh3pWvU30vMvqFqZnA0p1XwoW8fOrTt26pLqovELeyDb4e2+ERdhUvrbc4mM4n5fr9ZpUvwMxf581m0suWdYtT28lkwsr7Ipa23hULU/TUX7eqg4yi7xEZmw20Qe+S+1PbUvyaZK//Q0UF3EW1y9toNQ+9BTOBsQ=
Message-ID: <46AA844E.7010806@googlemail.com>
Date: Sat, 28 Jul 2007 01:48:30 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jdike@karaya.com
Subject: Re: UML compile error
References: <46AA75E1.10606@googlemail.com> <20070727162802.a52307dc.akpm@linux-foundation.org>
In-Reply-To: <20070727162802.a52307dc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 28 Jul 2007 00:46:57 +0200
> Gabriel C <nix.or.die@googlemail.com> wrote:
> 
>> UML does not compile on current git head. 
>>
>> ....
>> $ make defconfig ARCH=um
>> [..]
>> $ make  ARCH=um
>> scripts/kconfig/conf -s arch/um/Kconfig
>> net/bluetooth/hidp/Kconfig:4:warning: 'select' used by config symbol 'BT_HIDP' refers to undefined symbol 'HID'
>> drivers/net/wireless/Kconfig:552:warning: 'select' used by config symbol 'RTL8187' refers to undefined symbol 'EEPROM_93CX6'
>>   SYMLINK arch/um/include/kern_constants.h
>>   CHK     arch/um/include/uml-config.h
>>   UPD     arch/um/include/uml-config.h
>>   CC      arch/um/sys-i386/user-offsets.s
>>   CHK     arch/um/include/user_constants.h
>>   CHK     include/linux/version.h
>>   CHK     include/linux/utsrelease.h
>>   CC      arch/um/kernel/asm-offsets.s
>> In file included from include/linux/sched.h:54,
>>                  from arch/um/include/sysdep/kernel-offsets.h:2,
>>                  from arch/um/kernel/asm-offsets.c:1:
>> include/linux/jiffies.h:18:5: warning: "CONFIG_HZ" is not defined
>> include/linux/jiffies.h:20:7: warning: "CONFIG_HZ" is not defined
>> include/linux/jiffies.h:22:7: warning: "CONFIG_HZ" is not defined
>> include/linux/jiffies.h:24:7: warning: "CONFIG_HZ" is not defined
>> include/linux/jiffies.h:26:7: warning: "CONFIG_HZ" is not defined
>> include/linux/jiffies.h:28:7: warning: "CONFIG_HZ" is not defined
>> include/linux/jiffies.h:30:7: warning: "CONFIG_HZ" is not defined
> 
> I suspect your build setup broke.  Try `make mrproper' then
> have another go.
> 

Right this auto build tree broke for some reason.

A fresh git tree is fine ,  sorry for the noise.


Gabriel
