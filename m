Return-Path: <linux-kernel-owner+w=401wt.eu-S937806AbXGSJ1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937806AbXGSJ1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760665AbXGSJ0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:26:45 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:63995 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760838AbXGSJ0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:26:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fRnOCSMjIkV7od2mesMJQrmCut0Vl/K/ci2oLQnIO5e3Jl55cV2O0gLkUSgYlsDavX1+3LzC0YfFgJdqpj0eoOYaiK9IPoFdKcsXUAsMFvuAxfA8xPMyk5LL4IzEQMND//gxRWFpDVrMh8+p1SOnGRIODIRisdDvvHMnn0qWrwA=
Message-ID: <469F2E4A.1020502@gmail.com>
Date: Thu, 19 Jul 2007 18:26:34 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?R=FAben_Fonseca?= <krani1@0x82.com>
CC: Linux Kernel Mailling List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: libata [ata_piix] still no resume from S3 ?
References: <20070712162450.GA7132@0x82.com> <469744DB.5070600@gmail.com> <20070714210117.GA20723@0x82.com> <469DD216.5040305@gmail.com> <20070719092053.GA21254@0x82.com>
In-Reply-To: <20070719092053.GA21254@0x82.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rúben Fonseca wrote:
> On Wed, 18 Jul 2007, Tejun Heo wrote:
> 
>>> irq 23: nobody cared (try booting with the "irqpool" option)
>>>  __report_bad_irq
>>>  note_interrupt
>>>  handle_IRQ_event
>>>  handle_fasteoi_irq
>>>  do_IRQ
>>>  do_IRQ
>>>  irq_exit
>>>  smp_acpi_timer
>>>  common_interrupt
>>>  acpi_pm_read
>>>  getnstimeofday
>>>  ktime_get_ts
>>>  ktime_egt
>>>  tick_nohz_restart_sched_tick
>>>  cpu_idle
>>>  start_kernel
>>>  unkown_bootoption
>>>  =====
>>> handlers:
>>>  (ata_interrupt [libata])
>>>  (tifm_7xx1_isr [tifm_7xx1])
>>> Disabling IRQ #23
>>> (...)
>>> ATA: abnormal status 0x7F on port 0x000118cf
>>>
>>> And hard drive never cames up.. have to hard reboot the machine..
>>> Does it help?
>> Hmmm... That's 'nobody cared' during resume.  Please post the result of
>> 'lspci -nnvvv'.
> 
> 09:04.2 Mass storage controller [0180]: Texas Instruments 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS PRO/xD) [104c:803b]
> 	Subsystem: Sony Corporation Unknown device [104d:81e6]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 57 (1750ns min, 1000ns max), Cache Line Size: 64 bytes
> 	Interrupt: pin C routed to IRQ 23
> 	Region 0: Memory at dc004000 (32-bit, non-prefetchable) [size=4K]
> 	Capabilities: [44] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

Does the problem still occur if you disable the card reader?

-- 
tejun
