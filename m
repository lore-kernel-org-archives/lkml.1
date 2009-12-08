Return-Path: <linux-kernel-owner+w=401wt.eu-S966059AbZLHUcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966059AbZLHUcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937883AbZLHUcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:32:07 -0500
Received: from kroah.org ([198.145.64.141]:41631 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936711AbZLHUcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:32:04 -0500
Date: Tue, 8 Dec 2009 12:31:55 -0800
From: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.31.7
Message-ID: <20091208203155.GA21146@kroah.com>
References: <20091208193236.GC20016@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208193236.GC20016@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 11:32:36AM -0800, Greg KH wrote:
>  Makefile                                  |    2 
>  arch/x86/kernel/acpi/processor.c          |    3 

<snip>

I messed up and sent out the diffstat for 2.6.27.40, not 2.6.31.7.

Here's the correct diffstat.

thanks, and sorry for any confusion.

greg k-h

 Documentation/video4linux/gspca.txt            |    1 
 Makefile                                       |    2 
 arch/arm/include/asm/kmap_types.h              |    6 +
 arch/powerpc/include/asm/kmap_types.h          |   11 ++
 arch/sparc/kernel/prom_common.c                |    4 
 arch/sparc/kernel/visemul.c                    |    2 
 arch/x86/kernel/acpi/processor.c               |    3 
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c    |   19 +---
 drivers/char/agp/intel-agp.c                   |    8 +
 drivers/char/keyboard.c                        |    2 
 drivers/char/tty_port.c                        |   10 +-
 drivers/crypto/padlock-aes.c                   |    4 
 drivers/gpu/drm/Kconfig                        |    1 
 drivers/gpu/drm/drm_edid.c                     |    6 +
 drivers/gpu/drm/i915/i915_irq.c                |   10 ++
 drivers/gpu/drm/i915/intel_fb.c                |    8 -
 drivers/gpu/drm/radeon/radeon_fb.c             |    6 -
 drivers/hwmon/adt7475.c                        |    5 -
 drivers/i2c/i2c-core.c                         |   11 ++
 drivers/isdn/hisax/hfc_usb.c                   |    4 
 drivers/md/md.c                                |    5 -
 drivers/md/raid1.c                             |    8 +
 drivers/md/raid10.c                            |    1 
 drivers/md/raid5.c                             |    2 
 drivers/media/common/tuners/tda18271-fe.c      |    8 -
 drivers/media/dvb/dvb-usb/cxusb.c              |   10 ++
 drivers/media/dvb/frontends/dib7000p.c         |    5 +
 drivers/media/dvb/siano/smsusb.c               |    6 +
 drivers/media/radio/radio-gemtek-pci.c         |    2 
 drivers/media/video/bt8xx/bttv-driver.c        |   33 ++++++-
 drivers/media/video/em28xx/em28xx-audio.c      |    5 +
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c |   20 ++++
 drivers/media/video/gspca/sonixj.c             |   40 ++++-----
 drivers/media/video/s2255drv.c                 |    5 -
 drivers/media/video/saa7134/saa7134-cards.c    |    1 
 drivers/media/video/saa7134/saa7134-ts.c       |    6 -
 drivers/media/video/saa7134/saa7134.h          |    1 
 drivers/media/video/sn9c102/sn9c102_devtable.h |    2 
 drivers/media/video/v4l1-compat.c              |   14 +--
 drivers/mmc/host/pxamci.c                      |    4 
 drivers/net/acenic.c                           |    3 
 drivers/net/bonding/bond_main.c                |    8 -
 drivers/net/sfc/rx.c                           |    9 +-
 drivers/net/sky2.c                             |    2 
 drivers/net/usb/hso.c                          |    4 
 drivers/net/wireless/ath/ath5k/phy.c           |   24 +++--
 drivers/net/wireless/b43/dma.c                 |   36 ++++++--
 drivers/net/wireless/iwlwifi/iwl-1000.c        |    1 
 drivers/net/wireless/iwlwifi/iwl-6000.c        |    4 
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c      |    9 ++
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   10 +-
 drivers/net/wireless/iwlwifi/iwl-core.h        |    2 
 drivers/net/wireless/iwlwifi/iwl-tx.c          |   10 ++
 drivers/net/wireless/rtl818x/rtl8187_leds.c    |    4 
 drivers/pci/pcie/aer/aerdrv.c                  |    2 
 drivers/platform/x86/acerhdf.c                 |  111 ++++++++++++++++---------
 drivers/platform/x86/thinkpad_acpi.c           |    2 
 drivers/pps/kapi.c                             |   20 +++-
 drivers/pps/pps.c                              |   11 +-
 drivers/rtc/rtc-v3020.c                        |    2 
 drivers/scsi/gdth.c                            |    2 
 drivers/serial/of_serial.c                     |    1 
 drivers/usb/class/cdc-acm.c                    |    2 
 drivers/usb/core/hub.c                         |    2 
 drivers/usb/gadget/amd5536udc.c                |   49 ++++++-----
 drivers/usb/host/ehci-hcd.c                    |    2 
 drivers/usb/host/ehci-pci.c                    |    6 +
 drivers/usb/host/ehci-q.c                      |   16 +++
 drivers/usb/host/ehci-sched.c                  |   12 ++
 drivers/usb/host/ehci.h                        |    2 
 drivers/usb/host/ohci-hcd.c                    |    5 +
 drivers/usb/host/ohci-pci.c                    |   20 ++++
 drivers/usb/host/ohci-q.c                      |   18 ++--
 drivers/usb/host/ohci.h                        |    9 ++
 drivers/usb/host/xhci-mem.c                    |   10 +-
 drivers/usb/host/xhci-ring.c                   |    7 +
 drivers/usb/mon/mon_bin.c                      |   11 +-
 drivers/usb/musb/musb_gadget.c                 |   79 +++++++----------
 drivers/usb/serial/cp210x.c                    |   21 ++++
 drivers/usb/serial/ftdi_sio.c                  |    3 
 drivers/usb/serial/option.c                    |    2 
 fs/block_dev.c                                 |    2 
 fs/cifs/cifsproto.h                            |    1 
 fs/cifs/connect.c                              |    8 -
 fs/cifs/dir.c                                  |    6 -
 fs/cifs/inode.c                                |    7 -
 fs/cifs/misc.c                                 |   14 +++
 fs/cifs/readdir.c                              |    7 -
 fs/compat_ioctl.c                              |    4 
 fs/fuse/dir.c                                  |    3 
 fs/jffs2/read.c                                |    9 +-
 fs/nfs/nfs4proc.c                              |    2 
 fs/nilfs2/ioctl.c                              |   30 ++----
 fs/proc/base.c                                 |    3 
 include/linux/skbuff.h                         |    2 
 include/net/mac80211.h                         |    6 +
 include/net/netfilter/nf_conntrack.h           |    8 -
 include/net/netfilter/nf_nat_helper.h          |    4 
 init/main.c                                    |   11 --
 kernel/module.c                                |    5 -
 kernel/perf_counter.c                          |    2 
 kernel/sched.c                                 |    9 +-
 kernel/user.c                                  |    2 
 mm/highmem.c                                   |   17 ++-
 mm/migrate.c                                   |    2 
 mm/page_alloc.c                                |    4 
 net/core/datagram.c                            |   10 ++
 net/ipv4/ip_fragment.c                         |    2 
 net/ipv4/netfilter/nf_nat_core.c               |    3 
 net/ipv4/netfilter/nf_nat_helper.c             |   34 +++++--
 net/ipv4/udp.c                                 |   78 +++++++++--------
 net/ipv6/udp.c                                 |    4 
 net/mac80211/agg-rx.c                          |    4 
 net/mac80211/agg-tx.c                          |   17 +--
 net/mac80211/ht.c                              |    8 -
 net/mac80211/ieee80211_i.h                     |    2 
 net/netfilter/nf_conntrack_core.c              |    8 +
 net/netfilter/nf_conntrack_proto_tcp.c         |   64 +++++---------
 net/netfilter/xt_connlimit.c                   |   10 --
 net/rfkill/core.c                              |    1 
 net/sched/act_pedit.c                          |    2 
 net/sunrpc/svcsock.c                           |   10 +-
 security/integrity/ima/ima_iint.c              |    4 
 sound/arm/aaci.c                               |    6 +
 sound/core/rawmidi.c                           |   44 ++++-----
 sound/core/seq/seq_midi.c                      |    1 
 sound/pci/hda/patch_sigmatel.c                 |    2 
 sound/soc/codecs/tlv320aic23.c                 |    3 
 sound/soc/soc-dapm.c                           |   16 ++-
 sound/usb/usbaudio.h                           |    2 
 130 files changed, 878 insertions(+), 479 deletions(-)
