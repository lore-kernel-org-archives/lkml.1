Return-Path: <linux-kernel-owner+w=401wt.eu-S964932AbXDBRIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932AbXDBRIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 13:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933843AbXDBRIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 13:08:49 -0400
Received: from smtp-out1.libero.it ([212.52.84.41]:38457 "EHLO
	smtp-out1.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933741AbXDBRIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 13:08:48 -0400
X-Scanned: with antispam and antivirus automated system at libero.it
Message-ID: <461138B2.6040806@libero.it>
Date: Mon, 02 Apr 2007 19:09:06 +0200
From: Marco <marco4ever@libero.it>
User-Agent: Mozilla Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: MTRR Problem with 2.6.18-4
References: <JFVCLH$F3BAE0357982714B025306FB8CF4A0C1@libero.it>
In-Reply-To: <JFVCLH$F3BAE0357982714B025306FB8CF4A0C1@libero.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marco ha scritto:
> Hi everybody,
>
> Laptop: Sony VAIO VGN-SZ3VP/X
> Kernel: 2.6.18-4
>
> I have the following problem with mtrr:
>
> #cat /proc/mtrr
> reg00: base=0x00000000 (?? 0MB), size=2048MB: write-back, count=1
> reg01: base=0x7ff00000 (2047MB), size=?? 1MB: uncachable, count=1
>
> #lspci -v
> 01:00.0 VGA compatible controller: nVidia Corporation GeForce Go 7400 (rev a1) (prog-if 00 [VGA])
>  Subsystem: Sony Corporation Unknown device 81e6
>  Flags: bus master, fast devsel, latency 0, IRQ 5
>  Memory at dd000000 (32-bit, non-prefetchable) [size=16M]
>  Memory at c0000000 (64-bit, prefetchable) [size=256M]
>  Memory at dc000000 (64-bit, non-prefetchable) [size=16M]
>  Capabilities: [60] Power Management version 2
>  Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
>  Capabilities: [78] Express Endpoint IRQ 0
>  Capabilities: [100] Virtual Channel
>  Capabilities: [128] Power Budgeting
>
> Kernel boot option:
> kernel /vmlinuz-2.6.18-4-686 root=/dev/sda3 ro video=vesafb:mtrr,ywrap vga=792 acpi_sleep=s3_bios elevator=cfq resume2=swap:/dev/sda2 
>
> Can you help me to fix the "uncachable" reg?
> Thanks
>
> Marco
>   
Any idea? :'(
Regards

Marco

