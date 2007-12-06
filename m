Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbXLFUg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbXLFUg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbXLFUgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:36:18 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:41127 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbXLFUgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:36:17 -0500
Subject: Re: [PATCH 3/3] printer port driver: semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>
To: Remy Bohmer <linux@bohmer.net>
Cc: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org
In-Reply-To: <3efb10970712061212i7198f53eo5a8d8774465b3dde@mail.gmail.com>
References: <20071206021857.826386004@mvista.com>
	 <20071206021909.131993721@mvista.com> <20071206102334.GE17299@elte.hu>
	 <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com>
	 <20071206200542.GE480@traven>
	 <3efb10970712061212i7198f53eo5a8d8774465b3dde@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 06 Dec 2007 12:23:28 -0800
Message-Id: <1196972608.1568.118.camel@jnielson-xp.ddns.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-06 at 21:12 +0100, Remy Bohmer wrote:
> Hello Matthias,
> 
> Which do you have exactly on your list? (good to know, it prevents
> double work...)

Here's my list so far (in no particular order).. Most aren't tested
fully yet.. I'll try to post them someplace eventually (later today
maybe)

plip-sem-to-complete.patch
	linux-2.6.23/drivers/net/plip.c
spi-semaphore-to-mutex.patch
	linux-2.6.23/drivers/spi/spi.c
au1000-semaphore-to-mutex.patch
	linux-2.6.23/drivers/pcmcia/au1000_generic.c
soc_common-semaphore-to-mutex.patch
	linux-2.6.23/drivers/pcmcia/soc_common.c
	linux-2.6.23/drivers/pcmcia/soc_common.h
qla2xxx-semaphore-to-mutex.patch
	linux-2.6.23/drivers/scsi/qla2xxx/qla_os.c
bcm43xx-semaphore-to-mutex.patch
	linux-2.6.23/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c
adb_handler_sem-to-mutex.patch
	linux-2.6.23/drivers/macintosh/adb.c
therm_pm72-semaphore-to-mutex.patch
	linux-2.6.23/drivers/macintosh/therm_pm72.c
mbcs-semaphore-to-mutex.patch
	linux-2.6.23/drivers/char/mbcs.c
	linux-2.6.23/drivers/char/mbcs.h
ldusb-semaphore-to-mutex.patch
	linux-2.6.23/drivers/usb/misc/ldusb.c
u132-hdc-semaphore-to-mutex.patch
	linux-2.6.23/drivers/usb/host/u132-hcd.c
watchdog-wdt_pci.patch
	linux-2.6.23/drivers/watchdog/wdt_pci.c
mcheck_semaphore-to-mutex.patch
	linux-2.6.23/arch/x86/kernel/cpu/mcheck/mce_64.c
doc-kernel-locking-convert-semaphore-reference.patch
	linux-2.6.23/Documentation/DocBook/kernel-locking.tmpl
net-9p-trans_virtio-semaphore-to-mutex.patch
	linux-2.6.23/net/9p/trans_virtio.c
sound-s3c24xx-semaphore-to-mutex.patch
	linux-2.6.23/sound/soc/s3c24xx/s3c2443-ac97.c
usb-microtek-semaphore-to-mutex.patch
	linux-2.6.23/drivers/usb/image/microtek.c
	linux-2.6.23/drivers/usb/image/microtek.h
video-sa1100fb-semaphore-to-mutex.patch
	linux-2.6.23/drivers/video/sa1100fb.c
	linux-2.6.23/drivers/video/sa1100fb.h
video-pxafb-semaphore-to-mutex.patch
	linux-2.6.23/drivers/video/pxafb.c
	linux-2.6.23/drivers/video/pxafb.h
macintosh-windfarm_smu_sat-semaphore-to-mutex.patch
	linux-2.6.23/drivers/macintosh/windfarm_smu_sat.c
macintosh-therm_windtunnel-semaphore-to-mutex.patch
	linux-2.6.23/drivers/macintosh/therm_windtunnel.c
macintosh-mediabay-semaphore-to-mutex.patch
	linux-2.6.23/drivers/macintosh/mediabay.c
md-suspend_lock-semaphore-to-mutex.patch
	linux-2.6.23/drivers/md/dm.c
s390-cio-semaphore-to-mutex.patch
	linux-2.6.23/drivers/s390/cio/qdio.c
	linux-2.6.23/drivers/s390/cio/qdio.h
message-fusion-mpt-semaphore-to-mutex.patch
	linux-2.6.23/drivers/message/fusion/mptbase.c
	linux-2.6.23/drivers/message/fusion/mptbase.h
	linux-2.6.23/drivers/message/fusion/mptscsih.c
net-wan-cosa-semaphore-to-mutex.patch
	linux-2.6.23/drivers/net/wan/cosa.c
usbvision-video-error-patch-unlock-fix.patch
	linux-2.6.23/drivers/media/video/usbvision/usbvision-video.c
usbvision-video-semaphore-to-mutex.patch
	linux-2.6.23/drivers/media/video/usbvision/usbvision-video.c
	linux-2.6.23/drivers/media/video/usbvision/usbvision.h
ps3-vuart-locking-fix.patch
	linux-2.6.23/drivers/ps3/ps3-vuart.c
ps3-vuart-semaphore-to-mutex.patch
	linux-2.6.23/drivers/ps3/ps3-vuart.c
usbvision-video-remove-CtrlUrbLock.patch
	linux-2.6.23/drivers/media/video/usbvision/usbvision-core.c
	linux-2.6.23/drivers/media/video/usbvision/usbvision-video.c
	linux-2.6.23/drivers/media/video/usbvision/usbvision.h


