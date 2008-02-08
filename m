Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbYBHVBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbYBHVBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbYBHVBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:01:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:44533 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYBHVA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:00:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xnJF22qPPQAZ3VSpg2efkO7tGQD7ojJf3x3L9qmWN2MwW0VQbi2HG9o0VgSc3Yx+W911GrhmRwNAzcP9JgeE6UNJHJf/L6Te1533Ud5Eh70ntn+60gxKBZsxXOXWzul1Dc+ZVtLO9FzUk21ehT7oQAWRwzuc2yCI93kFS1k1JUE=
Message-ID: <6101e8c40802081300o3a978d9axef5ca3040d6a5839@mail.gmail.com>
Date: Fri, 8 Feb 2008 22:00:56 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: Linux 2.6.24.1
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
In-Reply-To: <20080208203404.GC4520@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080208203404.GC4520@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

the v2.6.24.y tree is not published or not visible with git-web on
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=summary
address

On 2/8/08, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> We (the -stable team) are announcing the release of the 2.6.24.1
> kernel.
>
> It contains a number of bugfixes all over the place, and all users of
> the 2.6.24 series are encouraged to upgrade.
>
> I'll also be replying to this message with a copy of the patch between
> 2.6.24 and 2.6.24.1
>
> The updated 2.6.24.y git tree can be found at:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.24.y.git
> and can be browsed at the normal kernel.org git web browser:
>
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=summary
>
> thanks,
>
> greg k-h
>
> --------
>  Documentation/video4linux/CARDLIST.cx23885  |    2 -
>  Makefile                                    |    4 +-
>  arch/x86/kernel/Makefile_32                 |    3 +
>  drivers/acpi/blacklist.c                    |   23 ++++++++------
>  drivers/acpi/osl.c                          |   16 ++++-----
>  drivers/base/firmware_class.c               |    3 +
>  drivers/char/drm/drm_stub.c                 |    1
>  drivers/char/drm/drm_vm.c                   |    2 +
>  drivers/char/mspec.c                        |    2 -
>  drivers/firmware/dmi_scan.c                 |    9 -----
>  drivers/media/video/cx23885/cx23885-cards.c |    4 ++
>  drivers/net/forcedeth.c                     |   16 ++++-----
>  drivers/net/sky2.c                          |   14 +++++---
>  drivers/net/wireless/b43/dma.c              |   28 +++++++++++++++--
>  drivers/net/wireless/b43/main.c             |   21 +++++++++++-
>  drivers/net/wireless/b43/xmit.c             |   20 +++++++++---
>  drivers/net/wireless/b43/xmit.h             |    2 -
>  drivers/net/wireless/b43legacy/dma.c        |   23 ++++++++++++--
>  drivers/net/wireless/b43legacy/main.c       |    9 ++++-
>  drivers/net/wireless/b43legacy/pio.c        |   21 ++++++++++--
>  drivers/net/wireless/b43legacy/xmit.c       |   15 +++++++--
>  drivers/net/wireless/b43legacy/xmit.h       |    2 -
>  drivers/pci/hotplug/fakephp.c               |   39 +++++++++++++++++++++--
>  drivers/usb/core/driver.c                   |    4 +-
>  drivers/usb/core/hub.c                      |    2 -
>  drivers/usb/gadget/fsl_usb2_udc.c           |    2 -
>  drivers/usb/misc/usbtest.c                  |    1
>  drivers/usb/serial/cp2101.c                 |    6 +++
>  drivers/usb/serial/ftdi_sio.c               |   46
> ++++++++++++++--------------
>  drivers/usb/serial/ftdi_sio.h               |    4 ++
>  drivers/usb/serial/keyspan.c                |    2 -
>  drivers/usb/serial/kobil_sct.c              |    1
>  drivers/usb/serial/option.c                 |    1
>  drivers/usb/serial/pl2303.c                 |    4 +-
>  drivers/usb/serial/pl2303.h                 |   13 +++++--
>  drivers/usb/serial/sierra.c                 |   13 +++++++
>  drivers/usb/storage/unusual_devs.h          |    8 ++++
>  fs/eventpoll.c                              |    2 -
>  fs/ncpfs/mmap.c                             |    4 --
>  fs/splice.c                                 |    8 ++++
>  include/linux/dmi.h                         |    2 -
>  include/linux/wait.h                        |   16 +++++++++
>  kernel/relay.c                              |    1
>  kernel/sched_fair.c                         |    8 +++-
>  mm/filemap.c                                |    8 +++-
>  mm/fremap.c                                 |    5 ++-
>  mm/mmap.c                                   |    2 -
>  mm/slab.c                                   |   46
> ++++++++++++++--------------
>  scripts/mod/file2alias.c                    |    2 -
>  security/selinux/ss/services.c              |    3 +
>  sound/oss/via82cxxx_audio.c                 |   14 +++-----
>  sound/usb/usx2y/usX2Yhwdep.c                |    2 -
>  sound/usb/usx2y/usx2yhwdeppcm.c             |    2 -
>  53 files changed, 360 insertions(+), 151 deletions(-)
>
> Summary of changes from v2.6.24 to v2.6.24.1
> ============================================
>
> Akira Tsukamoto (1):
>       USB: pl2303: add support for RATOC REX-USB60F
>
> Alan Cox (1):
>       USB: keyspan: Fix oops
>
> Ayaz Abdulla (1):
>       forcedeth: mac address mcp77/79
>
> Bruno Redondi (1):
>       USB: sierra: add support for Onda H600/Zte MF330 datacard to USB
> Driver for Sierra Wireless
>
> Craig Shelley (1):
>       USB: CP2101 New Device IDs
>
> Damien Stuart (1):
>       USB: Adding YC Cable USB Serial device to pl2303
>
> Daniel Kozák (1):
>       USB: remove duplicate entry in Option driver and Pl2303 driver for
> Huawei modem
>
> Dave Airlie (1):
>       drm: the drm really should call pci_set_master..
>
> Ed Beroset (1):
>       USB: ftdi driver - add support for optical probe device
>
> Franco Lanza (1):
>       USB: ftdi-sio: Patch to add vendor/device id for ATK_16IC CCD
>
> Grant Grundler (1):
>       USB: storage: Add unusual_dev for HP r707
>
> Greg Kroah-Hartman (2):
>       USB: handle idVendor of 0x0000
>       Linux 2.6.24.1
>
> Ian Abbott (1):
>       PCI: Fix fakephp deadlock
>
> Jan Andersson (1):
>       USB: fix usbtest halt check on big endian systems
>
> Jens Axboe (1):
>       splice: missing user pointer access verification (CVE-2008-0009/10)
>
> Jessica L. Blank (1):
>       USB: Sierra - Add support for Aircard 881U
>
> Kevin Lloyd (1):
>       USB: sierra driver - add devices
>
> Len Brown (1):
>       ACPI: update ACPI blacklist
>
> Li Yang (1):
>       usb gadget: fix fsl_usb2_udc potential OOPS
>
> Michael Buesch (4):
>       b43: Fix suspend/resume
>       b43: Drop packets we are not able to encrypt
>       b43: Fix dma-slot resource leakage
>       b43: Reject new firmware early
>
> Michael E Brown (1):
>       Driver core: Revert "Fix Firmware class name collision"
>
> Michael Krufky (1):
>       DVB: cx23885: add missing subsystem ID for Hauppauge HVR1800 Retail
>
> Nate Carlson (1):
>       USB: Variant of the Dell Wireless 5520 driver
>
> Nick Piggin (2):
>       vm audit: add VM_DONTEXPAND to mmap for drivers that need it
> (CVE-2008-0007)
>       fix writev regression: pan hanging unkillable and un-straceable
>
> Oleg Nesterov (1):
>       sys_remap_file_pages: fix ->vm_file accounting
>
> Oliver Neukum (1):
>       USB: use GFP_NOIO in reset path
>
> Pekka J Enberg (1):
>       slab: fix bootstrap on memoryless node
>
> Peter Stark (1):
>       USB: ftdi_sio - enabling multiple ELV devices, adding EM1010PC
>
> Peter Zijlstra (2):
>       lockdep: annotate epoll
>       sched: let +nice tasks have smaller impact
>
> Piotr Roszatycki (1):
>       USB: add support for 4348:5523 WinChipHead USB->RS 232 adapter
>
> Sam Ravnborg (1):
>       x86: restore correct module name for apm
>
> Srivatsa Vaddagiri (1):
>       sched: fix high wake up latencies with FAIR_USER_SCHED
>
> Stefan Bader (1):
>       USB: Fix usb_serial_driver structure for Kobil cardreader driver.
>
> Stefano Brivio (4):
>       b43legacy: fix PIO crash
>       b43legacy: fix suspend/resume
>       b43legacy: drop packets we are not able to encrypt
>       b43legacy: fix DMA slot resource leakage
>
> Stephen Hemminger (2):
>       sky2: restore multicast addresses after recovery
>       sky2: fix for WOL on some devices
>
> Stephen Smalley (1):
>       selinux: fix labeling of /proc/net inodes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
