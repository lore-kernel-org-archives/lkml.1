Return-Path: <linux-kernel-owner+w=401wt.eu-S1757132AbYD2RUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbYD2RUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbYD2RT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:19:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:42743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbYD2RT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:19:58 -0400
Date: Tue, 29 Apr 2008 10:17:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/37] 2.6.25-stable review
Message-ID: <20080429171730.GA14724@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.25.1 release.
There are 37 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Thursday, May 1 16:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.1-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team

---------------------

 Makefile                              |    2 
 arch/alpha/kernel/osf_sys.c           |    1 
 arch/x86/kernel/io_apic_32.c          |    1 
 arch/x86/pci/irq.c                    |   12 ++---
 drivers/infiniband/hw/nes/nes.c       |    4 -
 drivers/infiniband/hw/nes/nes_cm.c    |    6 +-
 drivers/infiniband/hw/nes/nes_hw.c    |   20 ++++-----
 drivers/md/dm-exception-store.c       |    2 
 drivers/media/video/cx88/cx88-cards.c |    4 +
 drivers/media/video/ivtv/ivtv-ioctl.c |    3 -
 drivers/media/video/tea5761.c         |   15 ++++--
 drivers/media/video/tuner-core.c      |    6 +-
 drivers/net/s2io.c                    |    4 -
 drivers/net/tehuti.c                  |   15 ++++++
 drivers/net/tg3.c                     |   52 ++++++++++++++++++++++--
 drivers/net/tg3.h                     |    1 
 drivers/net/wireless/b43/dma.c        |   73 ++++++++++++++++++++++++----------
 drivers/net/wireless/b43/main.c       |   28 ++++++++++++-
 drivers/rtc/rtc-pcf8583.c             |    2 
 drivers/scsi/qla2xxx/qla_os.c         |    2 
 drivers/serial/dz.c                   |    2 
 drivers/ssb/pci.c                     |    5 ++
 drivers/usb/core/hub.c                |    1 
 drivers/usb/host/ohci-pci.c           |    4 +
 drivers/usb/serial/sierra.c           |    1 
 fs/aio.c                              |   12 +++++
 fs/jffs2/erase.c                      |   18 +++-----
 include/linux/rtnetlink.h             |    4 -
 include/net/tcp.h                     |    7 ++-
 include/net/xfrm.h                    |    3 +
 kernel/cgroup.c                       |    7 ++-
 kernel/hrtimer.c                      |   34 +++++++++++++--
 mm/pagewalk.c                         |    8 ++-
 net/can/raw.c                         |    3 -
 net/core/rtnetlink.c                  |    6 ++
 net/dccp/probe.c                      |    2 
 net/ipv4/tcp_probe.c                  |    9 +---
 net/key/af_key.c                      |    2 
 net/rose/af_rose.c                    |    6 +-
 net/tipc/socket.c                     |    4 -
 net/xfrm/xfrm_policy.c                |    2 
 net/xfrm/xfrm_user.c                  |    2 
 security/selinux/hooks.c              |   15 +++++-
 43 files changed, 307 insertions(+), 103 deletions(-)

