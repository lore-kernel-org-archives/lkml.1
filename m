Return-Path: <linux-kernel-owner+w=401wt.eu-S1758297AbZAWSrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbZAWSrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 13:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbZAWSrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 13:47:09 -0500
Received: from chudak.whitesoft.cz ([81.92.149.98]:43581 "EHLO
	chudak.whitesoft.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbZAWSrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 13:47:08 -0500
Message-ID: <497A10A8.8030501@century.cz>
Date: Fri, 23 Jan 2009 19:47:04 +0100
From: =?UTF-8?B?UGV0ciBUaXTEm3Jh?= <P.Titera@century.cz>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Build error on x86
References: <497A09C4.2050500@century.cz> <20090123183343.GB5984@elte.hu>
In-Reply-To: <20090123183343.GB5984@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar napsal(a):
> * Petr Titěra <P.Titera@century.cz> wrote:
>
>   
>> Hello,
>>
>> i've got this during series of repeated randconfig errors.
>>
>> CC arch/x86/lguest/boot.o
>> In file included from  
>> /home/century.cz/owl/scm/linux-2.6/arch/x86/include/asm/smp.h:19,
>> from include/linux/smp.h:13,
>> from include/linux/irq.h:12,
>> from arch/x86/lguest/boot.c:50:
>> /home/century.cz/owl/scm/linux-2.6/arch/x86/include/asm/thread_info.h:35: 
>> error: field restart_blockâ has incomplete type
>> make[1]: *** [arch/x86/lguest/boot.o] Error 1
>> make: *** [arch/x86/lguest] Error 2
>>
>> Config and full build log attached. Is randconfig supposed to give valid  
>> config every time?
>>     
>
> hm, i cannot reproduce your build failure with latest -git 
> (v2.6.29-rc2-13-gf3b8436), using your config-1232519930.
>
>   
> Can you reproduce with latest -git? (your config suggests you are still 
> testing with .29-rc1) If it still occurs, which compiler version are you 
> using?
>
>   
I'm testing it just now. It seems to build. Time to rework my build 
scripts. Sorry for the noise.

> 	Ingo
>   

