Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbYH0KKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbYH0KKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 06:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbYH0KJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 06:09:55 -0400
Received: from ms01.sssup.it ([193.205.80.99]:49899 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754788AbYH0KJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 06:09:55 -0400
Message-ID: <48B527E3.6070204@evidence.eu.com>
Date: Wed, 27 Aug 2008 12:09:39 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Marc Pignat <marc.pignat@hevs.ch>
CC: lg@denx.de, rmk+kernel@arm.linux.org.uk,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ARM] Regression ? at91rm9200 machine-type
References: <48B3DB29.5070409@evidence.eu.com> <200808261443.12638.marc.pignat@hevs.ch>
In-Reply-To: <200808261443.12638.marc.pignat@hevs.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Pignat ha scritto:
> Hi!
> 
> On Tuesday 26 August 2008, you wrote:
>> Hi,
>>
>>     I have a custom board equivalent to AT91RM9200DK.
> If it is really equivalent, you can use the same MACH_TYPE, else you should
> register another.

I used the same MACH_TYPE.

> 
>> After commit
>>
>> 87fee013a23ad02821699aef5b76891b42959182
>>
>> [ARM] 4647/1: at91rm9200: Remove redundant machine-type verification
>> and manipulation
>>
>> I cannot boot my board anymore.
>>
>> Some more details:
>>   - I tried booting from both U-Boot 1.1.6 and U-Boot 1.3.4
>>   - I compiled U-Boot using "at91rm9200dk_config"
>>   - On U-Boot bootargs=console=ttyS0,115200 mem=32M
>> mtdparts=AT45DB642.spi0:-(filesystem) rootfstype=jffs2 root=/dev/mtdblock0
>>   - The .config of the kernel is in attachment
>>
>> I don't know if this is an actual regression or not (I'm not much
>> skilled in machine-types/boot process).
> 
> The "default machine" selection is a *hack* for machines with a bootloader too
> old, buggy or closed source.
> 
> The right fix is to change the MACH_TYPE that you've compiled in u-boot.
> 
>> However, it seems that the commit above, besides removing redundant 
>> machine type verification, removed the default machine type for 
>> unknown boards as well.
> 
> This is a cleanup patch, if the hack is not removed, bootloaders will *never*
> be fixed...

I see. Thank you for the explanations. Linux developers made things in
the right way by removing redundant machine type verification.

The bug is in U-Boot which passes the wrong mach type when compiled
for the at91rm9200dk board.

Many thanks for your quick answer.

              Claudio

-- 
Ing. Claudio Scordino		
Software Engineer, PhD
Tel. +39-050-5492050
http://retis.sssup.it/~scordino/

Evidence Srl
Embedded Real-Time Solutions
http://www.evidence.eu.com

