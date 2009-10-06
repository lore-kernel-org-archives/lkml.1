Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbZJFIHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbZJFIHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 04:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbZJFIHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 04:07:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40024 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475AbZJFIHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 04:07:01 -0400
Date: Tue, 6 Oct 2009 09:58:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, linux-input@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 32-rc1 aka 32-rc2: warning at manage.c:361 (set_irq_wake),
	matrix-keypad related?
Message-ID: <20091006075816.GA1362@ucw.cz>
References: <20090930200746.GA1384@ucw.cz> <20091006050649.GH27881@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <20091006050649.GH27881@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

On Mon 2009-10-05 22:06:50, Dmitry Torokhov wrote:
> On Wed, Sep 30, 2009 at 10:07:46PM +0200, Pavel Machek wrote:
> > 
> > It complains about unbalanced irq 113 wake disable. That one belongs
> > to matrix-keypad...
> 
> I guess some of enable_irq_wake()s fail on your box. Do you see it if
> you apply the patch below?

I'll do short test. But... if you are right, your patch will just make
your machine refuse to suspend... right?

Ungood.

Actually, it seems to break suspend (returns  -EINVAL while refusing
to suspend), warnings are still there, and keyboard is dead after
failed suspend... double plus ungood.

Aha, so warning is solved: the one in the log is from gpio_buttons.

(I wonder if the 'unbalanced irq_wake' warning is useful... who added it?)
 
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="1.msg"

info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty32
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty63
PM: Adding info for No Bus:ptmx
PM: Adding info for No Bus:apm_bios
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
PM: Adding info for platform:serial8250
platform serial8250: __pm_runtime_idle()!
platform serial8250: __pm_runtime_idle() returns -11!
PM: Adding info for No Bus:ttyS0
PM: Adding info for No Bus:ttyS1
PM: Adding info for No Bus:ttyS2
PM: Adding info for No Bus:ttyS3
serial8250 serial8250: __pm_runtime_idle()!
serial8250 serial8250: __pm_runtime_idle() returns -11!
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
NAND device: Manufacturer ID: 0xec, Chip ID: 0x73 (Samsung NAND 16MiB 3,3V 8-bit)
Scanning device for bad blocks
Creating 3 MTD partitions on "sharpsl-nand":
0x000000000000-0x000000700000 : "System Area"
PM: Adding info for No Bus:mtd0
PM: Adding info for No Bus:mtd0ro
PM: Adding info for No Bus:mtdblock0
PM: Adding info for No Bus:31:0
0x000000700000-0x000000c00000 : "Root Filesystem"
PM: Adding info for No Bus:mtd1
PM: Adding info for No Bus:mtd1ro
PM: Adding info for No Bus:mtdblock1
0x000000c00000-0x000001000000 : "Home Filesystem"
PM: Adding info for No Bus:mtd2
PM: Adding info for No Bus:mtd2ro
PM: Adding info for No Bus:mtdblock2
sharpsl-nand sharpsl-nand: __pm_runtime_idle()!
sharpsl-nand sharpsl-nand: __pm_runtime_idle() returns -11!
PPP generic driver version 2.4.2
PM: Adding info for No Bus:ppp
orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
PM: Adding info for No Bus:mice
mice: PS/2 mouse device common for all mice
PM: Adding info for No Bus:input0
input: gpio-keys as /class/input/input0
PM: Adding info for No Bus:event0
gpio-keys gpio-keys: __pm_runtime_idle()!
gpio-keys gpio-keys: __pm_runtime_idle() returns -11!
PM: Adding info for No Bus:input1
input: matrix-keypad as /class/input/input1
PM: Adding info for No Bus:event1
matrix-keypad matrix-keypad: __pm_runtime_idle()!
matrix-keypad matrix-keypad: __pm_runtime_idle() returns -11!
PM: Adding info for No Bus:hwmon0
ads7846 spi2.0: touchscreen, irq 107
PM: Adding info for No Bus:input2
input: ADS7846 Touchscreen as /class/input/input2
PM: Adding info for No Bus:mouse0
PM: Adding info for No Bus:event2
ads7846 spi2.0: __pm_runtime_idle()!
ads7846 spi2.0: __pm_runtime_idle() returns -11!
APM Battery Driver
PM: Adding info for No Bus:hwmon1
max1111 spi2.2: __pm_runtime_idle()!
max1111 spi2.2: __pm_runtime_idle() returns -11!
Bluetooth: HCI UART driver ver 2.2
Bluetooth: HCI H4 protocol initialized
Bluetooth: HCI BCSP protocol initialized
cpuidle: using governor ladder
PM: Adding info for No Bus:mmc0
pxa2xx-mci pxa2xx-mci.0: __pm_runtime_idle()!
pxa2xx-mci pxa2xx-mci.0: __pm_runtime_idle() returns -11!
PM: Adding info for No Bus:spitz:amber:charge
Registered led device: spitz:amber:charge
PM: Adding info for No Bus:spitz:green:hddactivity
Registered led device: spitz:green:hddactivity
leds-gpio leds-gpio: __pm_runtime_idle()!
leds-gpio leds-gpio: __pm_runtime_idle() returns -11!
wacom driver registered
TCP cubic registered
NET: Registered protocol family 17
Bluetooth: L2CAP ver 2.14
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
XScale iWMMXt coprocessor detected.
sharpsl-pm sharpsl-pm: __pm_runtime_idle()!
sharpsl-pm sharpsl-pm: __pm_runtime_idle() returns -11!
PM: Adding info for No Bus:cpu_dma_latency
PM: Adding info for No Bus:network_latency
PM: Adding info for No Bus:network_throughput
Waiting 3sec before mounting root device...
pcmcia_socket pcmcia_socket1: pccard: PCMCIA card inserted into slot 1
pcmcia 1.0: pcmcia: registering new device pcmcia1.0
PM: Adding info for pcmcia:1.0
Probing IDE interface ide0...
hda: HMS360404D5CF00, CFA DISK drive
PM: Adding info for No Bus:ide0
PM: Adding info for No Bus:ide0
ide0 at 0xc4840000-0xc4840007,0xc484000e on irq 202
PM: Adding info for ide:0.0
PM: Adding info for No Bus:0.0
hda: max request size: 128KiB
hda: 7999488 sectors (4095 MB) w/128KiB Cache, CHS=7936/16/63
hda: cache flushes supported
PM: Adding info for No Bus:hda
 hda: hda1 hda2 hda3
PM: Adding info for No Bus:hda1
PM: Adding info for No Bus:hda2
PM: Adding info for No Bus:hda3
PM: Adding info for No Bus:3:0
ide-gd 0.0: __pm_runtime_idle()!
ide-gd 0.0: __pm_runtime_idle() returns -11!
ide-cs: hda: Vpp = 0.0
ide-cs 1.0: __pm_runtime_idle()!
ide-cs 1.0: __pm_runtime_idle() returns -11!
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly on device 3:3.
Freeing init memory: 92K
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on hda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on hda2, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
Adding 55160k swap on /SWAP.  Priority:-1 extents:15 across:55220k 
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
PM: Adding info for No Bus:vcs63
PM: Adding info for No Bus:vcsa63
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Entering mem sleep
platform pxa27x-udc: preparing suspend
platform pxa2xx-uart.0: preparing suspend
platform pxa2xx-uart.1: preparing suspend
platform pxa2xx-uart.2: preparing suspend
platform pxa2xx-i2s: preparing suspend
platform sa1100-rtc: preparing suspend
platform pxa-rtc: preparing suspend
pxa27x-ssp pxa27x-ssp.0: preparing suspend
pxa27x-ssp pxa27x-ssp.1: preparing suspend
pxa27x-ssp pxa27x-ssp.2: preparing suspend
platform pxa27x-pwm.0: preparing suspend
platform pxa27x-pwm.1: preparing suspend
pxa2xx-spi pxa2xx-spi.2: preparing suspend
sharp-scoop sharp-scoop.0: preparing suspend
matrix-keypad matrix-keypad: preparing suspend, may wakeup
gpio-keys gpio-keys: preparing suspend, may wakeup
leds-gpio leds-gpio: preparing suspend
sharpsl-nand sharpsl-nand: preparing suspend
platform physmap-flash: preparing suspend
pxa2xx-mci pxa2xx-mci.0: preparing suspend
platform pxa27x-ohci: preparing suspend
platform pxa2xx-ir: preparing suspend
pxa2xx-fb pxa2xx-fb: preparing suspend
pxa2xx-i2c pxa2xx-i2c.0: preparing suspend
sharp-scoop sharp-scoop.1: preparing suspend
platform regulatory.0: preparing suspend
pxa2xx-pcmcia pxa2xx-pcmcia: preparing suspend
sharpsl-pm sharpsl-pm: preparing suspend
serial8250 serial8250: preparing suspend
ide-gd 0.0: legacy suspend
ide-cs 1.0: legacy suspend
leds spitz:green:hddactivity: legacy class suspend
leds spitz:amber:charge: legacy class suspend
input input2: type suspend
input input1: type suspend
input input0: type suspend
mtd mtd2ro: legacy class suspend
mtd mtd2: legacy class suspend
mtd mtd1ro: legacy class suspend
mtd mtd1: legacy class suspend
mtd mtd0ro: legacy class suspend
mtd mtd0: legacy class suspend
serial8250 serial8250: suspend
backlight corgi_bl: legacy class suspend
sharpsl-pm sharpsl-pm: suspend
pxa2xx-pcmcia pxa2xx-pcmcia: suspend
platform regulatory.0: suspend
i2c i2c-0: legacy suspend
max1111 spi2.2: legacy suspend
corgi-lcd spi2.1: legacy suspend
ads7846 spi2.0: legacy suspend
sharp-scoop sharp-scoop.1: suspend
pxa2xx-i2c pxa2xx-i2c.0: suspend
pxa2xx-fb pxa2xx-fb: suspend
platform pxa2xx-ir: suspend
platform pxa27x-ohci: suspend
pxa2xx-mci pxa2xx-mci.0: suspend
platform physmap-flash: suspend
sharpsl-nand sharpsl-nand: suspend
leds-gpio leds-gpio: suspend
gpio-keys gpio-keys: suspend, may wakeup
matrix-keypad matrix-keypad: suspend, may wakeup
matrix-keypad matrix-keypad: Failed to setup GPIO 17 as wakeup source, err: -22
pm_op(): platform_pm_suspend+0x0/0x5c returns -22
PM: Device matrix-keypad failed to suspend: error -22
PM: Some devices failed to suspend
gpio-keys gpio-keys: resume
------------[ cut here ]------------
WARNING: at kernel/irq/manage.c:361 set_irq_wake+0x7c/0x138()
Unbalanced IRQ 191 wake disable
Modules linked in:
[<c00248f8>] (unwind_backtrace+0x0/0xe4) from [<c003520c>] (warn_slowpath_common+0x4c/0x80)
[<c003520c>] (warn_slowpath_common+0x4c/0x80) from [<c003527c>] (warn_slowpath_fmt+0x28/0x38)
[<c003527c>] (warn_slowpath_fmt+0x28/0x38) from [<c0060b88>] (set_irq_wake+0x7c/0x138)
[<c0060b88>] (set_irq_wake+0x7c/0x138) from [<c01d0274>] (gpio_keys_resume+0x64/0x80)
[<c01d0274>] (gpio_keys_resume+0x64/0x80) from [<c0190d3c>] (platform_pm_resume+0x30/0x54)
[<c0190d3c>] (platform_pm_resume+0x30/0x54) from [<c019302c>] (pm_op+0x6c/0x8c)
[<c019302c>] (pm_op+0x6c/0x8c) from [<c0193af4>] (dpm_resume_end+0xf0/0x47c)
[<c0193af4>] (dpm_resume_end+0xf0/0x47c) from [<c005d980>] (suspend_devices_and_enter+0x8c/0x1dc)
[<c005d980>] (suspend_devices_and_enter+0x8c/0x1dc) from [<c005dbb8>] (enter_state+0xe8/0x120)
[<c005dbb8>] (enter_state+0xe8/0x120) from [<c005d2bc>] (state_store+0x90/0xc4)
[<c005d2bc>] (state_store+0x90/0xc4) from [<c01459bc>] (kobj_attr_store+0x1c/0x24)
[<c01459bc>] (kobj_attr_store+0x1c/0x24) from [<c00d80d8>] (sysfs_write_file+0x104/0x18c)
[<c00d80d8>] (sysfs_write_file+0x104/0x18c) from [<c008ffe8>] (vfs_write+0xb0/0x164)
[<c008ffe8>] (vfs_write+0xb0/0x164) from [<c009016c>] (sys_write+0x40/0x70)
[<c009016c>] (sys_write+0x40/0x70) from [<c001fec0>] (ret_fast_syscall+0x0/0x28)
---[ end trace 974713f34f14652d ]---
leds-gpio leds-gpio: resume
sharpsl-nand sharpsl-nand: resume
platform physmap-flash: resume
pxa2xx-mci pxa2xx-mci.0: resume
platform pxa27x-ohci: resume
platform pxa2xx-ir: resume
pxa2xx-fb pxa2xx-fb: resume
pxa2xx-i2c pxa2xx-i2c.0: resume
sharp-scoop sharp-scoop.1: resume
ads7846 spi2.0: legacy resume
corgi-lcd spi2.1: legacy resume
max1111 spi2.2: legacy resume
i2c i2c-0: legacy resume
platform regulatory.0: resume
pxa2xx-pcmcia pxa2xx-pcmcia: resume
sharpsl-pm sharpsl-pm: resume
backlight corgi_bl: legacy class resume
serial8250 serial8250: resume
mtd mtd0: legacy class resume
mtd mtd0ro: legacy class resume
mtd mtd1: legacy class resume
mtd mtd1ro: legacy class resume
mtd mtd2: legacy class resume
mtd mtd2ro: legacy class resume
input input0: type resume
input input1: type resume
input input2: type resume
leds spitz:amber:charge: legacy class resume
leds spitz:green:hddactivity: legacy class resume
ide-cs 1.0: legacy resume
ide-gd 0.0: legacy resume
serial8250 serial8250: completing resume
sharpsl-pm sharpsl-pm: completing resume
pxa2xx-pcmcia pxa2xx-pcmcia: completing resume
platform regulatory.0: completing resume
sharp-scoop sharp-scoop.1: completing resume
pxa2xx-i2c pxa2xx-i2c.0: completing resume
pxa2xx-fb pxa2xx-fb: completing resume
platform pxa2xx-ir: completing resume
platform pxa27x-ohci: completing resume
pxa2xx-mci pxa2xx-mci.0: completing resume
platform physmap-flash: completing resume
sharpsl-nand sharpsl-nand: completing resume
leds-gpio leds-gpio: completing resume
gpio-keys gpio-keys: completing resume
matrix-keypad matrix-keypad: completing resume
sharp-scoop sharp-scoop.0: completing resume
pxa2xx-spi pxa2xx-spi.2: completing resume
platform pxa27x-pwm.1: completing resume
platform pxa27x-pwm.0: completing resume
pxa27x-ssp pxa27x-ssp.2: completing resume
pxa27x-ssp pxa27x-ssp.1: completing resume
pxa27x-ssp pxa27x-ssp.0: completing resume
platform pxa-rtc: completing resume
platform sa1100-rtc: completing resume
platform pxa2xx-i2s: completing resume
platform pxa2xx-uart.2: completing resume
platform pxa2xx-uart.1: completing resume
platform pxa2xx-uart.0: completing resume
platform pxa27x-udc: completing resume
PM: Finishing wakeup.
Restarting tasks ... done.
hda: task_pio_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
hda: task_pio_intr: error=0x04 { DriveStatusError }
hda: possibly failed opcode: 0xc4
hda: task_pio_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
hda: task_pio_intr: error=0x04 { DriveStatusError }
hda: possibly failed opcode: 0xc4
hda: task_pio_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
hda: task_pio_intr: error=0x04 { DriveStatusError }
hda: possibly failed opcode: 0xc4
hda: task_pio_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
hda: task_pio_intr: error=0x04 { DriveStatusError }
hda: possibly failed opcode: 0xc4
ide0: reset: success

--Qxx1br4bt0+wmkIi--
