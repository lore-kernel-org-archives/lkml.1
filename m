Return-Path: <linux-kernel-owner+w=401wt.eu-S1761864AbZJIXnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761864AbZJIXnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761706AbZJIXmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:42:53 -0400
Received: from kroah.org ([198.145.64.141]:51489 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761687AbZJIXmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:42:51 -0400
Date: Fri, 9 Oct 2009 16:38:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/26] 2.6.31.4-stable review
Message-ID: <20091009233812.GA15982@kroah.com>
References: <20091009231249.GA31084@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009231249.GA31084@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 04:12:49PM -0700, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.31.4 release.
> There are 26 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.

Oops, a bunch of network patches came in right when this went out, and I
don't want to have to wait to get them on, so I've rolled a -rc2 version
now.

There's now 37 patches in this series, I'll attach the rest to this
thread now.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.31.4-rc2.gz
and the diffstat can be found below.


thanks,

greg k-h

-----------

 .../networking/timestamping/timestamping.c         |    2 +-
 Makefile                                           |    2 +-
 arch/x86/ia32/ia32entry.S                          |   36 +++++++----
 arch/x86/include/asm/checksum_32.h                 |    3 +-
 arch/x86/kernel/acpi/cstate.c                      |    2 +-
 arch/x86/kernel/i8253.c                            |   27 ++++++--
 arch/x86/kvm/lapic.c                               |    2 +-
 arch/x86/kvm/svm.c                                 |    2 +
 arch/x86/kvm/vmx.c                                 |    2 +-
 arch/x86/kvm/x86.c                                 |    2 +
 drivers/acpi/osl.c                                 |    8 ++-
 drivers/ata/libata-eh.c                            |   50 +++++++++-----
 drivers/char/tty_ldisc.c                           |    7 +--
 drivers/ide/sis5513.c                              |   10 ++-
 drivers/net/appletalk/ipddp.c                      |    3 +-
 drivers/net/iseries_veth.c                         |    2 +-
 drivers/net/sky2.c                                 |    4 +-
 drivers/net/tun.c                                  |    4 +-
 drivers/net/usb/smsc95xx.c                         |    2 +-
 drivers/net/usb/usbnet.c                           |    2 +-
 fs/ecryptfs/main.c                                 |    7 ++-
 fs/namei.c                                         |    6 +-
 include/linux/ftrace.h                             |    2 +-
 include/linux/usb/usbnet.h                         |    1 +
 kernel/exit.c                                      |    2 -
 kernel/fork.c                                      |   10 ++-
 kernel/futex.c                                     |    3 +-
 kernel/time/tick-sched.c                           |    9 ++-
 kernel/trace/ftrace.c                              |   23 ++-----
 mm/swap_state.c                                    |   70 +++++++++++++-------
 net/appletalk/aarp.c                               |   16 +++--
 net/appletalk/ddp.c                                |   58 +++++++++--------
 net/ax25/af_ax25.c                                 |    6 +-
 net/core/dev.c                                     |    6 +-
 net/core/sock.c                                    |   19 ++++--
 net/ipv4/tcp_minisocks.c                           |    2 +-
 net/ipv6/sit.c                                     |    2 +-
 net/unix/af_unix.c                                 |    5 +-
 sound/pci/hda/patch_realtek.c                      |    1 +
 sound/pci/via82xx.c                                |   27 +++++---
 sound/soc/codecs/wm8350.c                          |    4 +-
 41 files changed, 277 insertions(+), 174 deletions(-)
