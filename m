Return-Path: <linux-kernel-owner+w=401wt.eu-S934057AbXGSPEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934057AbXGSPEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbXGSPEC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:04:02 -0400
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:36868 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752130AbXGSPD7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:03:59 -0400
X-AntiVirus: PTMail-AV 0.3-0.90.3
Date: Thu, 19 Jul 2007 16:04:36 +0100
From: =?iso-8859-1?Q?R=FAben?= Fonseca <krani1@0x82.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Linux Kernel Mailling List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: libata [ata_piix] still no resume from S3 ?
Message-ID: <20070719150436.GA9006@0x82.com>
References: <20070712162450.GA7132@0x82.com> <469744DB.5070600@gmail.com> <20070714210117.GA20723@0x82.com> <469DD216.5040305@gmail.com> <20070719092053.GA21254@0x82.com> <469F2E4A.1020502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <469F2E4A.1020502@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Tejun Heo wrote:

> Rúben Fonseca wrote:
> > On Wed, 18 Jul 2007, Tejun Heo wrote:
> > 
> >>> irq 23: nobody cared (try booting with the "irqpool" option)
> >>>  __report_bad_irq
> >>>  note_interrupt
> >>>  handle_IRQ_event
> >>>  handle_fasteoi_irq
> >>>  do_IRQ
> >>>  do_IRQ
> >>>  irq_exit
> >>>  smp_acpi_timer
> >>>  common_interrupt
> >>>  acpi_pm_read
> >>>  getnstimeofday
> >>>  ktime_get_ts
> >>>  ktime_egt
> >>>  tick_nohz_restart_sched_tick
> >>>  cpu_idle
> >>>  start_kernel
> >>>  unkown_bootoption
> >>>  =====
> >>> handlers:
> >>>  (ata_interrupt [libata])
> >>>  (tifm_7xx1_isr [tifm_7xx1])
> >>> Disabling IRQ #23
> >>> (...)
> >>> ATA: abnormal status 0x7F on port 0x000118cf
> >>>
> >>> And hard drive never cames up.. have to hard reboot the machine..
> >>> Does it help?
> >> Hmmm... That's 'nobody cared' during resume.  Please post the result of
> >> 'lspci -nnvvv'.
> > 
> > 09:04.2 Mass storage controller [0180]: Texas Instruments 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS PRO/xD) [104c:803b]
> > 	Subsystem: Sony Corporation Unknown device [104d:81e6]
> > 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> > 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> > 	Latency: 57 (1750ns min, 1000ns max), Cache Line Size: 64 bytes
> > 	Interrupt: pin C routed to IRQ 23
> > 	Region 0: Memory at dc004000 (32-bit, non-prefetchable) [size=4K]
> > 	Capabilities: [44] Power Management version 2
> > 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
> > 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> Does the problem still occur if you disable the card reader?

I wish I could disable this card reader. It is built in on the hardware,
and there are no drivers for Linux. There is no option on the BIOS to
disable the device. Is there any way (kernel parameters, magic program,
etc) to disable this device without opening my laptop to cut the wires?
:D

Ruben

-- 
Will work for bandwidth
