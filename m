Return-Path: <linux-kernel-owner+w=401wt.eu-S968350AbXEHQdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968350AbXEHQdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968217AbXEHQdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:33:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:22625 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbXEHQdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:33:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MyxdKxZxSL/RI99ECwYmBpp/ZEoOWts+RBetgW/aMDEziCVm9V/8lW28Myi++COCfbx6Bt7ieSGNhbzS7yWSVpQYmDqfxTIAoGK0C0fHr12LFkARZ4rhNDSqN92ExoBJljAzxaj4t85AWWzxzTi8CobQBuJM8dTpDCOmMkgFKO4=
Message-ID: <a44ae5cd0705080933t1e69a3c7heeaae3065faba804@mail.gmail.com>
Date: Tue, 8 May 2007 09:33:47 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.21 -- Lid button won't initiate suspend. Also, suspend didn't enter low-power state until I touched my mousepad.
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>
In-Reply-To: <200705081232.50510.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0705072334l1fe9afcs5eae4e684116a9c4@mail.gmail.com>
	 <200705081232.50510.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, Rafael.  Resending since I forgot to "reply all" before.

On 5/8/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> On Tuesday, 8 May 2007 08:34, Miles Lane wrote:
> > Firstly, all my attempts to get suspend to start by pressing my
> > laptop's lid button are failing.
> >
> > Here's the log info from about eight attempts::
>
> linux-acpi added to the CC list.
>
> > [   66.080135] ACPI: AC Adapter [ACAD] (on-line)
> > [   66.201949] ACPI: Battery Slot [BAT0] (battery present)
> > [   66.237885] input: Power Button (FF) as /class/input/input2
> > [   66.252274] ACPI: Power Button (FF) [PWRF]
> > [   66.267691] input: Lid Switch as /class/input/input3
> > [   66.280884] ACPI: Lid Switch [LID0]
> > [   66.296423] input: Sleep Button (CM) as /class/input/input4
> > [   66.309328] ACPI: Sleep Button (CM) [SLPB]
> > [   66.324930] No dock devices found.
> > [   66.369537] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> > [   66.386972] ACPI: Video Device [GFX0] (multi-head: yes  rom: yes  post: no)
> > [   50.683328] Time: acpi_pm clocksource has been installed.
> > [   53.729994] [ACPI Debug]  String: [0x1C] "Temperature increasing: _Q80"
> > [   54.203327] eth0: link down
> > [   55.933327] PM: Adding info for No Bus:vcs7
> > [   55.933327] PM: Adding info for No Bus:vcsa7
> > [   56.396661] ppdev: user-space parallel port driver
> > [   56.449994] PM: Removing info for No Bus:vcs7
> > [   56.449994] PM: Removing info for No Bus:vcsa7
> > [   56.649994] PM: Adding info for No Bus:vcs7
> > [   56.649994] PM: Adding info for No Bus:vcsa7
> > [   57.483327] [drm] Initialized drm 1.1.0 20060810
> > [   57.533327] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level,
> > low) -> IRQ 18
> > [   57.539994] [drm] Initialized i915 1.6.0 20060119 on minor 0
> > [   57.543327] [drm] Initialized i915 1.6.0 20060119 on minor 1
> > [   60.216660] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
> > [   60.219993] PM: Adding info for No Bus:apm_bios
> > [   61.366660] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> > [   61.629993] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
> > recovery directory
> > [   61.689993] NFSD: starting 90-second grace period
> > [   62.766660] usb usb4: usb auto-resume
> > [   62.766660] usb usb4: finish resume
> > [   62.766660] hub 4-0:1.0: hub_resume
> > [   62.769993] usb usb4: wakeup_rh
> > [   62.806660] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
> > [   62.806660] usb usb3: usb auto-resume
> > [   62.806660] usb usb3: finish resume
> > [   62.806660] hub 3-0:1.0: hub_resume
> > [   62.806660] usb usb3: wakeup_rh
> > [   62.843327] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
> > [   62.843327] usb usb1: usb auto-resume
> > [   62.843327] usb usb1: finish resume
> > [   62.843327] hub 1-0:1.0: hub_resume
> > [   62.843327] usb usb1: wakeup_rh
> > [   62.879993] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
> > [   62.879993] usb usb2: usb auto-resume
> > [   62.879993] usb usb2: finish resume
> > [   62.879993] hub 2-0:1.0: hub_resume
> > [   62.879993] ehci_hcd 0000:00:1d.7: resume root hub
> > [   62.913327] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
> > [   63.269993] Clocksource tsc unstable (delta = -166083281 ns)
> > [   63.796660] usb usb4: suspend_rh (auto-stop)
> > [   63.833326] usb usb3: suspend_rh (auto-stop)
> > [   63.869993] usb usb1: suspend_rh (auto-stop)
> > [   64.806660] hub 4-0:1.0: hub_suspend
> > [   64.806660] usb usb4: suspend_rh
> > [   64.806660] usb usb4: usb auto-suspend
> > [   64.843326] hub 3-0:1.0: hub_suspend
> > [   64.843326] usb usb3: suspend_rh
> > [   64.843326] usb usb3: usb auto-suspend
> > [   64.879993] hub 1-0:1.0: hub_suspend
> > [   64.879993] usb usb1: suspend_rh
> > [   64.879993] usb usb1: usb auto-suspend
> > [   64.913326] hub 2-0:1.0: hub_suspend
> > [   64.913326] ehci_hcd 0000:00:1d.7: suspend root hub
> > [   64.913326] usb usb2: usb auto-suspend
> > [   68.549993] usb usb4: usb auto-resume
> > [   68.549993] usb usb4: finish resume
> > [   68.553326] hub 4-0:1.0: hub_resume
> > [   68.553326] usb usb4: wakeup_rh
> > [   68.593326] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
> > [   68.593326] usb usb3: usb auto-resume
> > [   68.596659] usb usb3: finish resume
> > [   68.599993] hub 3-0:1.0: hub_resume
> > [   68.599993] usb usb3: wakeup_rh
> > [   68.626659] Bluetooth: Core ver 2.11
> > [   68.626659] PM: Adding info for platform:bluetooth
> > [   68.629993] NET: Registered protocol family 31
> > [   68.629993] Bluetooth: HCI device and connection manager initialized
> > [   68.629993] Bluetooth: HCI socket layer initialized
> > [   68.683326] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
> > [   68.686659] usb usb1: usb auto-resume
> > [   68.686659] usb usb1: finish resume
> > [   68.686659] hub 1-0:1.0: hub_resume
> > [   68.686659] usb usb1: wakeup_rh
> > [   68.723326] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
> > [   68.723326] usb usb2: usb auto-resume
> > [   68.723326] usb usb2: finish resume
> > [   68.723326] hub 2-0:1.0: hub_resume
> > [   68.723326] ehci_hcd 0000:00:1d.7: resume root hub
> > [   68.746659] Bluetooth: L2CAP ver 2.8
> > [   68.746659] Bluetooth: L2CAP socket layer initialized
> > [   68.763326] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
> > [   68.826659] Bluetooth: RFCOMM socket layer initialized
> > [   68.826659] Bluetooth: RFCOMM TTY layer initialized
> > [   68.826659] Bluetooth: RFCOMM ver 1.8
> > [   69.583326] usb usb4: suspend_rh (auto-stop)
> > [   69.673326] usb usb3: suspend_rh (auto-stop)
> > [   69.713326] usb usb1: suspend_rh (auto-stop)
> > [   70.593326] hub 4-0:1.0: hub_suspend
> > [   70.593326] usb usb4: suspend_rh
> > [   70.593326] usb usb4: usb auto-suspend
> > [   70.686659] hub 3-0:1.0: hub_suspend
> > [   70.686659] usb usb3: suspend_rh
> > [   70.686659] usb usb3: usb auto-suspend
> > [   70.689992] [ACPI Debug]  String: [0x1C] "Temperature increasing: _Q80"
> > [   73.759992] hub 1-0:1.0: hub_suspend
> > [   73.759992] usb usb1: suspend_rh
> > [   73.759992] usb usb1: usb auto-suspend
> > [   73.759992] hub 2-0:1.0: hub_suspend
> > [   73.759992] ehci_hcd 0000:00:1d.7: suspend root hub
> > [   73.759992] usb usb2: usb auto-suspend
> > [   89.083324] [ACPI Debug]  String: [0x1C] "Temperature increasing: _Q80"
> > [   91.086657] [ACPI Debug]  String: [0x1C] "Temperature increasing: _Q80"
> > [   93.116657] NET: Registered protocol family 10
> >
> > Then I tried initiating a suspend from the Gnome System menu.  The
> > suspend proceeded until the screen went black, but the disk stayed
> > spun up and the LEDs on the keyboards stayed lit up.  When I touched
> > the synaptics mousepad, the system entered the low power state.
>
> Did it wake up?  Your log ends at the "early resume" stage.

Yes.

> > On subsequent attempts to enter the suspend state, I didn't need to
> > touch the mouse to get it to work.
> >
> > Here is the log information from the flawed suspend process.  I don't
> > see anything indicating the mousepad activity:
>
> It probably only generated an interrupt that allowed the system to complete
> the suspend.
>
> Do you have CONFIG_NO_HZ set?

Yes.

> > [  540.193279] PM: Preparing system for mem sleep
> > [  540.203279] Stopping tasks ... done.
> > [  541.229945] Suspending console(s)
> > [  541.229945] platform bluetooth: suspend
> > [  541.229945] ac97 0-0:unknown codec: suspend
> > [  541.229945] iTCO_wdt iTCO_wdt: suspend
> > [  541.229945]  usbdev4.1: PM: suspend 0->2, parent usb4 already 2
> > [  541.229945]  usbdev4.1_ep81: PM: suspend 0->2, parent 4-0:1.0 already 2
> > [  541.229945] hub 4-0:1.0: PM: suspend 2-->2
> > [  541.229945] hub 4-0:1.0: PM: suspend 2->2, parent usb4 already 2
> > [  541.229945]  usbdev4.1_ep00: PM: suspend 0->2, parent usb4 already 2
> > [  541.229945] usb usb4: PM: suspend 2-->2
> > [  541.229945]  usbdev3.1: PM: suspend 0->2, parent usb3 already 2
> > [  541.229945]  usbdev3.1_ep81: PM: suspend 0->2, parent 3-0:1.0 already 2
> > [  541.229945] hub 3-0:1.0: PM: suspend 2-->2
> > [  541.229945] hub 3-0:1.0: PM: suspend 2->2, parent usb3 already 2
> > [  541.229945]  usbdev3.1_ep00: PM: suspend 0->2, parent usb3 already 2
> > [  541.229945] usb usb3: PM: suspend 2-->2
> > [  541.229945]  usbdev2.1: PM: suspend 0->2, parent usb2 already 2
> > [  541.229945]  usbdev2.1_ep81: PM: suspend 0->2, parent 2-0:1.0 already 2
> > [  541.229945] hub 2-0:1.0: PM: suspend 2-->2
> > [  541.229945] hub 2-0:1.0: PM: suspend 2->2, parent usb2 already 2
> > [  541.229945]  usbdev2.1_ep00: PM: suspend 0->2, parent usb2 already 2
> > [  541.229945] usb usb2: PM: suspend 2-->2
> > [  541.229945] sr 1:0:0:0: suspend
> > [  541.229945] sd 0:0:0:0: suspend
> > [  542.726612]  usbdev1.1: PM: suspend 0->2, parent usb1 already 2
> > [  542.726612]  usbdev1.1_ep81: PM: suspend 0->2, parent 1-0:1.0 already 2
> > [  542.726612] hub 1-0:1.0: PM: suspend 2-->2
> > [  542.726612] hub 1-0:1.0: PM: suspend 2->2, parent usb1 already 2
> > [  542.726612]  usbdev1.1_ep00: PM: suspend 0->2, parent usb1 already 2
> > [  542.726612] usb usb1: PM: suspend 2-->2
> > [  542.726612] psmouse serio1: suspend
> > [  543.093279] atkbd serio0: suspend
> > [  546.719945] i8042 i8042: suspend
> > [  546.719945] serial8250 serial8250: suspend
> > [  546.719945] vesafb vesafb.0: suspend
> > [  546.719945] platform pcspkr: suspend
> > [  546.719945] i8042 aux 00:06: suspend
> > [  546.719945] i8042 kbd 00:05: suspend
> > [  546.719945] system 00:04: suspend
> > [  546.719945] pnp 00:03: suspend
> > [  546.719945] pnp 00:02: suspend
> > [  546.719945] pnp 00:01: suspend, may wakeup
> > [  546.719945] pnp 00:00: suspend
> > [  546.719945] sdhci 0000:01:09.4: suspend
> > [  546.719945] sdhci [sdhci_suspend()]: Suspending...
> > [  546.719945] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
> > [  546.719945] mmc1: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
> > [  546.719945] mmc2: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
> > [  546.719945] ACPI: PCI interrupt for device 0000:01:09.4 disabled
> > [  546.733278] tifm_7xx1 0000:01:09.3: suspend
> > [  546.733278] ACPI: PCI interrupt for device 0000:01:09.3 disabled
> > [  546.746611] ohci1394 0000:01:09.2: suspend
> > [  546.759945] yenta_cardbus 0000:01:09.0: suspend
> > [  546.759945] pci 0000:01:06.0: suspend
> > [  546.759945] pci 0000:01:00.0: suspend
> > [  546.759945] pci 0000:00:1f.6: suspend
> > [  546.759945] Intel ICH 0000:00:1f.5: suspend
> > [  546.759945] codec_write 0: semaphore is not ready for register 0x26
> > [  546.759945] ACPI: PCI interrupt for device 0000:00:1f.5 disabled
> > [  546.759945] pci 0000:00:1f.3: suspend
> > [  546.759945] ata_piix 0000:00:1f.1: suspend
> > [  546.759945] ACPI: PCI interrupt for device 0000:00:1f.1 disabled
> > [  546.759945] pci_set_power_state(): 0000:00:1f.1: state=3, current state=5
> > [  546.759945] pci 0000:00:1f.0: suspend
> > [  546.759945] pci 0000:00:1e.0: suspend
> > [  546.759945] ehci_hcd 0000:00:1d.7: suspend, may wakeup
> > [  546.759945] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
> > [  546.773278] ehci_hcd 0000:00:1d.7: --> PCI D3/wakeup
> > [  546.773278] uhci_hcd 0000:00:1d.2: suspend
> > [  546.773278] uhci_hcd 0000:00:1d.2: uhci_suspend
> > [  546.773278] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
> > [  546.773278] uhci_hcd 0000:00:1d.2: --> PCI D0/legacy
> > [  546.773278] uhci_hcd 0000:00:1d.1: suspend
> > [  546.773278] uhci_hcd 0000:00:1d.1: uhci_suspend
> > [  546.773278] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
> > [  546.773278] uhci_hcd 0000:00:1d.1: --> PCI D0/legacy
> > [  546.773278] uhci_hcd 0000:00:1d.0: suspend
> > [  546.773278] uhci_hcd 0000:00:1d.0: uhci_suspend
> > [  546.773278] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
> > [  546.773278] uhci_hcd 0000:00:1d.0: --> PCI D0/legacy
> > [  546.773278] pci 0000:00:02.1: suspend
> > [  546.773278] pci 0000:00:02.0: suspend
> > [  546.773278] pci 0000:00:00.3: suspend
> > [  546.773278] pci 0000:00:00.1: suspend
> > [  546.773278] agpgart-intel 0000:00:00.0: suspend
> > [  546.773278] acpi thermal:01: suspend
> > [  546.773278] acpi thermal:00: suspend
> > [  546.773278] acpi pnp0c14:00: suspend
> > [  546.773278] acpi device:18: suspend
> > [  546.773278] acpi device:17: suspend
> > [  546.773278] acpi device:16: suspend
> > [  546.773278] acpi device:15: suspend
> > [  546.773278] acpi device:14: suspend
> > [  546.773278] acpi device:13: suspend
> > [  546.773278] acpi device:12: suspend
> > [  546.773278] acpi device:11: suspend
> > [  546.773278] acpi device:10: suspend
> > [  546.773278] acpi device:0f: suspend
> > [  546.773278] acpi device:0e: suspend
> > [  546.773278] acpi device:0d: suspend
> > [  546.773278] acpi device:0c: suspend
> > [  546.773278] acpi device:0b: suspend
> > [  546.773278] acpi SYN0110:00: suspend
> > [  546.773278] acpi PNP0303:00: suspend
> > [  546.773278] ec PNP0C09:00: suspend
> > [  546.773278] acpi PNP0C02:00: suspend
> > [  546.773278] acpi PNP0200:00: suspend
> > [  546.773278] acpi PNP0C04:00: suspend
> > [  546.773278] acpi PNP0B00:00: suspend
> > [  546.773278] acpi PNP0000:00: suspend
> > [  546.773278] acpi PNP0100:00: suspend
> > [  546.773278] pci_link PNP0C0F:07: suspend
> > [  546.773278] pci_link PNP0C0F:06: suspend
> > [  546.773278] pci_link PNP0C0F:05: suspend
> > [  546.773278] pci_link PNP0C0F:04: suspend
> > [  546.773278] pci_link PNP0C0F:03: suspend
> > [  546.773278] pci_link PNP0C0F:02: suspend
> > [  546.773278] pci_link PNP0C0F:01: suspend
> > [  546.773278] pci_link PNP0C0F:00: suspend
> > [  546.773278] acpi device:0a: suspend
> > [  546.773278] acpi device:09: suspend
> > [  546.773278] acpi device:08: suspend
> > [  546.773278] acpi device:07: suspend
> > [  546.773278] acpi device:06: suspend
> > [  546.773278] acpi device:05: suspend
> > [  546.773278] acpi device:04: suspend
> > [  546.773278] acpi device:03: suspend
> > [  546.773278] acpi device:02: suspend
> > [  546.773278] video video:00: suspend
> > [  546.773278] acpi device:01: suspend
> > [  546.773278] pci_root PNP0A03:00: suspend
> > [  546.773278] button PNP0C0E:00: suspend
> > [  546.773278] button PNP0C0D:00: suspend
> > [  546.773278] battery PNP0C0A:00: suspend
> > [  546.773278] ac ACPI0003:00: suspend
> > [  546.773278] acpi device:00: suspend
> > [  546.773278] processor ACPI0007:00: suspend
> > [  546.773278] button button_power:00: suspend
> > [  546.773278] acpi acpi_system:00: suspend
> > [  546.773278] PM: Entering mem sleep
> > [  546.773278] platform bluetooth: LATE suspend
> > [  546.773278] iTCO_wdt iTCO_wdt: LATE suspend
> > [  546.773278] serial8250 serial8250: LATE suspend
> > [  546.773278] vesafb vesafb.0: LATE suspend
> > [  546.773278] platform pcspkr: LATE suspend
> > [  546.773278] sdhci 0000:01:09.4: LATE suspend
> > [  546.773278] tifm_7xx1 0000:01:09.3: LATE suspend
> > [  546.773278] ohci1394 0000:01:09.2: LATE suspend
> > [  546.773278] yenta_cardbus 0000:01:09.0: LATE suspend
> > [  546.773278] pci 0000:01:06.0: LATE suspend
> > [  546.773278] pci 0000:01:00.0: LATE suspend
> > [  546.773278] pci 0000:00:1f.6: LATE suspend
> > [  546.773278] Intel ICH 0000:00:1f.5: LATE suspend
> > [  546.773278] pci 0000:00:1f.3: LATE suspend
> > [  546.773278] pci 0000:00:1f.0: LATE suspend
> > [  546.773278] pci 0000:00:1e.0: LATE suspend
> > [  546.773278] pci 0000:00:02.1: LATE suspend
> > [  546.773278] pci 0000:00:02.0: LATE suspend
> > [  546.773278] pci 0000:00:00.3: LATE suspend
> > [  546.773278] pci 0000:00:00.1: LATE suspend
> > [  546.773278] agpgart-intel 0000:00:00.0: LATE suspend
> > [  546.773278]  hwsleep-0323 [03] enter_sleep_state     : Entering
> > sleep state [S3]
> > [  546.773278] Intel machine check architecture supported.
> > [  546.773278] Intel machine check reporting enabled on CPU#0.
> > [  546.773278] Back to C!
> > [  546.773278] agpgart-intel 0000:00:00.0: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:00:00.0
> > [  546.773278] pci 0000:00:00.1: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:00:00.1
> > [  546.773278] pci 0000:00:00.3: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:00:00.3
> > [  546.773278] pci 0000:00:02.0: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:00:02.0
> > [  546.773278] pci 0000:00:02.1: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:00:02.1
> > [  546.773278] uhci_hcd 0000:00:1d.0: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:00:1d.0
> > [  546.773278] uhci_hcd 0000:00:1d.1: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:00:1d.1
> > [  546.773278] uhci_hcd 0000:00:1d.2: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:00:1d.2
> > [  546.773278] ehci_hcd 0000:00:1d.7: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:00:1d.7
> > [  546.773278] pci 0000:00:1e.0: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:00:1e.0
> > [  546.773278] pci 0000:00:1f.0: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be541 for 0000:00:1f.0
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:00:1f.0
> > [  546.773278] ata_piix 0000:00:1f.1: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:00:1f.1
> > [  546.773278] pci 0000:00:1f.3: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:00:1f.3
> > [  546.773278] Intel ICH 0000:00:1f.5: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:00:1f.5
> > [  546.773278] pci 0000:00:1f.6: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:00:1f.6
> > [  546.773278] pci 0000:01:00.0: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:01:00.0
> > [  546.773278] pci 0000:01:06.0: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:01:06.0
> > [  546.773278] yenta_cardbus 0000:01:09.0: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:01:09.0
> > [  546.773278] ohci1394 0000:01:09.2: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:01:09.2
> > [  546.773278] tifm_7xx1 0000:01:09.3: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:01:09.3
> > [  546.773278] sdhci 0000:01:09.4: EARLY resume
> > [  546.773278] PCI: Calling quirk c01be2f7 for 0000:01:09.4
> > [  546.773278] platform pcspkr: EARLY resume
> > [  546.773278] vesafb vesafb.0: EARLY resume
> > [  546.773278] serial8250 serial8250: EARLY resume
