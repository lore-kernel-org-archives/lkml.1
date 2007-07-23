Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbXGWOFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbXGWOFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbXGWOEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:04:51 -0400
Received: from hu-out-0506.google.com ([72.14.214.238]:2502 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbXGWOEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:04:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=m6l+CBX1Tx+WO0IcAJTxNOA6jYa5daTsNCBI5HIXGj6XBnHM/NQiTJxsrh5BPWHRR+Vs+wbiT2gbBh09r38sOtynjkhZMk4ekNo1NbgI1ZYf6GoM1Au7SqLW0xKznuVDivoScHSHlqTac66MYTwyAqpbHBnAUp43Yueq4JqbsJ0=
Message-ID: <46A4B4E7.5000404@googlemail.com>
Date: Mon, 23 Jul 2007 16:02:15 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Josh Boyer <jwboyer@gmail.com>
CC: Jan Dittmer <jdi@l4x.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: alpha, i386,mips,powerpc,ppc,xtensa compile brakage (was Re:
 Linus 2.6.23-rc1)
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>	 <46A45544.8090303@l4x.org> <625fc13d0707230657r62144bd0i190d9b21a5641429@mail.gmail.com>
In-Reply-To: <625fc13d0707230657r62144bd0i190d9b21a5641429@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer wrote:
> On 7/23/07, Jan Dittmer <jdi@l4x.org> wrote:
>> # ppc/bamboo_defconfig: broke
>>
>>    GEN     .version
>>    CHK     include/linux/compile.h
>>    UPD     include/linux/compile.h
>>    CC      init/version.o
>>    LD      init/built-in.o
>>    LD      .tmp_vmlinux1
>> drivers/built-in.o(.text+0x1ebda): In function `store_uevent':
>> drivers/base/core.c:312: undefined reference to `kobject_actions'
>> drivers/built-in.o(.text+0x1ebe6):drivers/base/core.c:312: undefined reference to `kobject_actions'
>> make[1]: *** [.tmp_vmlinux1] Error 1
>> make: *** [_all] Error 2
> 
> This is the HOTPLUG one that GregKH knows about and has a patch for I
> think.  Not PPC specific.

Yes CONFIG_HOTPLUG=n 

See http://lkml.org/lkml/2007/7/22/303 , there is an link to the patch.


> 
> josh

Regards,

Gabriel C
