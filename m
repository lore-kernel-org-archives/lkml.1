Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394Ab0AEUFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab0AEUFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005Ab0AEUFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:05:53 -0500
Received: from kroah.org ([198.145.64.141]:60465 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab0AEUFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:05:53 -0500
Date: Tue, 5 Jan 2010 12:03:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Subject: [00/39] 2.6.31.10 stable review
Message-ID: <20100105200316.GA29726@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.31.10 release.
There are 39 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, Jan 7, 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
      kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.31.10-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                       |    2 +-
 arch/x86/include/asm/processor.h               |    2 +-
 arch/x86/kernel/ptrace.c                       |   16 +-
 drivers/ata/pata_cmd64x.c                      |    2 +-
 drivers/ata/pata_hpt3x2n.c                     |   64 ++++----
 drivers/dma/at_hdmac.c                         |    4 +-
 drivers/hwmon/fschmd.c                         |    2 +-
 drivers/hwmon/sht15.c                          |    6 +-
 drivers/i2c/chips/tsl2550.c                    |    3 +
 drivers/input/keyboard/atkbd.c                 |    9 +
 drivers/md/md.c                                |    8 +-
 drivers/media/video/ov511.c                    |    2 +-
 drivers/net/e100.c                             |   19 ++-
 drivers/net/usb/rtl8150.c                      |    2 +-
 drivers/net/wireless/hostap/hostap_main.c      |    3 +-
 drivers/net/wireless/iwmc3200wifi/iwm.h        |    2 +-
 drivers/net/wireless/libertas/wext.c           |    2 -
 drivers/net/wireless/rt2x00/rt61pci.c          |    5 +
 drivers/platform/x86/acerhdf.c                 |    7 +-
 drivers/s390/block/dasd_diag.c                 |   19 ++-
 drivers/scsi/scsi_transport_fc.c               |   17 ++-
 drivers/usb/misc/appledisplay.c                |    4 +-
 drivers/usb/misc/emi62.c                       |    2 +-
 drivers/usb/musb/musb_gadget_ep0.c             |   14 +-
 drivers/usb/serial/option.c                    |    5 +
 fs/cifs/connect.c                              |   13 +-
 fs/ext4/ext4.h                                 |    6 +-
 fs/ext4/inode.c                                |   36 ++--
 fs/ext4/mballoc.c                              |    6 -
 fs/ext4/super.c                                |    5 +
 fs/namei.c                                     |    1 +
 fs/quota/dquot.c                               |  213 +++++++++++++-----------
 fs/stat.c                                      |   10 +-
 fs/udf/super.c                                 |   32 +++-
 fs/xfs/xfs_log_recover.c                       |    4 +-
 include/linux/fs.h                             |    1 +
 include/linux/quota.h                          |    5 +-
 include/net/ipv6.h                             |    7 +
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |    2 +-
 kernel/time/clockevents.c                      |   18 ++-
 mm/memcontrol.c                                |    8 +-
 mm/oom_kill.c                                  |    2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   13 ++-
 net/ipv6/netfilter/nf_conntrack_reasm.c        |    7 +-
 net/ipv6/reassembly.c                          |    5 +-
 sound/mips/sgio2audio.c                        |    2 +-
 sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c         |    2 +-
 sound/soc/codecs/wm9712.c                      |    3 +-
 sound/usb/usbaudio.c                           |    2 +-
 49 files changed, 396 insertions(+), 228 deletions(-)
