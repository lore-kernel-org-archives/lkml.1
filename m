Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbYDZNa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbYDZNa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 09:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYDZNaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 09:30:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:58474 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYDZNaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 09:30:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=SnGii0K18NBiYIeQYsgy+luOZ2zK78BYemCkf6ZH+Is9salEMUkP2kSvuUGeRkSXHnp2Bul2mqO0Tk2zEa6adH+gjUpUn2k9t/Pdsb3WunGrI845XNZYZuDKHWLCsOgOnLO4U0t6S9i5GODjufAU84wiccg1TCuP/rpU7egUeDU=
Message-ID: <48132E65.4020607@gmail.com>
Date: Sat, 26 Apr 2008 17:30:13 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       thomas@winischhofer.net
Subject: Re: [REGRESSEION] x86: allyesconfig fails with 'debug' symbol
References: <48131440.8090609@gmail.com> <20080426114302.GD2252@cs181133002.pp.htv.fi>
In-Reply-To: <20080426114302.GD2252@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk пишет:
> On Sat, Apr 26, 2008 at 03:38:40PM +0400, Dmitri Vorobiev wrote:
>> Hi,
>>
>> The last commit as of writing this regression report is
>> b1721d0da266b4af8cb4419473b4ca36206ab200, and I'm using Linus tree.
>>
>> The allyesconfig build fails with the following error:
>>
>> [dmitri.vorobiev@amber linux-2.6]$ make ARCH=i386 CROSS_COMPILE=i386-linux-gnu- 
>>
>> [ ... skipped ... ]
>>
>>   LD      vmlinux.o
>> drivers/built-in.o: In function `SiS_EnableBridge':
>> /home/dmitri.vorobiev/Projects/misc/zoo/src/linux-2.6/drivers/video/sis/init301.c:4352: multiple definition of `debug'
>> arch/x86/kernel/built-in.o:/home/dmitri.vorobiev/Projects/misc/zoo/src/linux-2.6/arch/x86/kernel/entry_32.S:766: first defined here
>> i386-linux-gnu-ld: Warning: size of symbol `debug' changed from 76 in arch/x86/kernel/built-in.o to 4 in drivers/built-in.o
>> make: *** [vmlinux.o] Error 1
>> [dmitri.vorobiev@amber linux-2.6]$
>>
>> Although it is obvious what causes this problem, just now I have no time
>> to try to resolve this, so I decided to just report the failure.
> 
> Fix:
>   http://lkml.org/lkml/2008/4/25/376

Tested successfully. Thank you, Adrian.

Dmitri

> 
>> Thanks,
>> Dmitri
> 
> cu
> Adrian
> 

