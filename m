Return-Path: <linux-kernel-owner+w=401wt.eu-S1760915AbXGaOV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915AbXGaOV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbXGaOVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:21:50 -0400
Received: from people.fsn.hu ([195.228.252.137]:65442 "EHLO people.fsn.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394AbXGaOVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:21:49 -0400
Message-ID: <46AF4570.7070606@fsn.hu>
Date: Tue, 31 Jul 2007 16:21:36 +0200
From: Attila Nagy <bra@fsn.hu>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: Hangs and reboots under high loads, oops with DEBUG_SHIRQ
References: <46AE0420.4030900@fsn.hu> <20070730171953.5fe93979@the-village.bc.nu>
In-Reply-To: <20070730171953.5fe93979@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.07.30. 18:19, Alan Cox wrote:
> O> MCE:
>   
>> [153103.918654] HARDWARE ERROR
>> [153103.918655] CPU 1: Machine Check Exception:                5 Bank 0: 
>> b200004010000400
>> [153104.066037] RIP !INEXACT! 10:<ffffffff802569e6> {mwait_idle+0x46/0x60}
>> [153104.145699] TSC 1167e915e93ce
>> [153104.183554] This is not a software problem!
>> [153104.234724] Run through mcelog --ascii to decode and contact your 
>> hardware vendor
>>     
>
> If you it through mcelog as it suggests it wil decode the meaning of the
> MCE data and that should give you some idea. Generally speaking MCE
> errors are real hardware errors but can certainly be caused by external
> factors (power supply glitches, heat etc)
>   
Sorry, of course I ran that through mcelog, but inadvertently attached 
the original version.

I've tried the machines with two types of power sources (different 
UPSes, line filtering, etc,
and the chassis have redundant PSes), monitoring the temperatures (seems 
to be OK,
the CPUs don't go over 30 °C even under load). I have the latest BIOS 
for the
motherboard.
But I will recheck everything.

BTW, here's the output from mcelog, I see this occasionally on all four 
machines:

HARDWARE ERROR
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 1 BANK 0 TSC 1167e915e93ce
MCG status:RIPV MCIP
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: Internal Timer error
STATUS b200004010000400 MCGSTATUS 5
This is not a software problem!
Run through mcelog --ascii to decode and contact your hardware vendor

HARDWARE ERROR
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 1 BANK 5 TSC 1167e915e9ea8
MCG status:RIPV MCIP
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: Internal Timer error
STATUS b200221024080400 MCGSTATUS 5
This is not a software problem!
Run through mcelog --ascii to decode and contact your hardware vendor

Thanks,

