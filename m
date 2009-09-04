Return-Path: <linux-kernel-owner+w=401wt.eu-S933969AbZIDUNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969AbZIDUNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933902AbZIDUNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:13:50 -0400
Received: from kroah.org ([198.145.64.141]:36080 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933884AbZIDUNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:13:49 -0400
Date: Fri, 4 Sep 2009 13:11:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/48] 2.6.27.32-stable review
Message-ID: <20090904201112.GA8274@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.32 release.
There are 48 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Sunday, Sept 6, 20:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.32-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

---------

 Makefile                              |    2 +-
 arch/x86/kvm/mmu.c                    |   63 ++++++++-------
 arch/x86/kvm/svm.c                    |    1 -
 arch/x86/kvm/vmx.c                    |   25 +++++-
 arch/x86/kvm/vmx.h                    |    1 +
 arch/x86/kvm/x86.c                    |  146 +++++++++++++++++++++++----------
 drivers/char/mxser.c                  |    2 -
 drivers/char/nozomi.c                 |    1 -
 drivers/net/ehea/ehea_main.c          |    3 +
 drivers/parport/share.c               |   13 ++-
 drivers/scsi/sr_ioctl.c               |    5 +
 drivers/usb/serial/cyberjack.c        |    7 --
 drivers/usb/serial/cypress_m8.c       |    4 -
 drivers/usb/serial/empeg.c            |    6 --
 drivers/usb/serial/garmin_gps.c       |    8 --
 drivers/usb/serial/generic.c          |    6 --
 drivers/usb/serial/io_edgeport.c      |    8 --
 drivers/usb/serial/io_ti.c            |    8 --
 drivers/usb/serial/ipaq.c             |    6 --
 drivers/usb/serial/ipw.c              |    3 -
 drivers/usb/serial/iuu_phoenix.c      |    1 -
 drivers/usb/serial/kobil_sct.c        |    6 --
 drivers/usb/serial/mos7720.c          |    7 --
 drivers/usb/serial/mos7840.c          |    6 --
 drivers/usb/serial/option.c           |    3 -
 drivers/usb/serial/sierra.c           |    3 -
 drivers/usb/serial/ti_usb_3410_5052.c |   17 +----
 drivers/usb/serial/visor.c            |    8 --
 fs/ocfs2/aops.c                       |   64 ++++++++++----
 include/asm-x86/kvm_host.h            |   10 ++
 include/linux/parport.h               |    4 +
 include/linux/sunrpc/xprt.h           |    1 +
 kernel/fork.c                         |   21 ++----
 kernel/kthread.c                      |    2 +-
 kernel/signal.c                       |   15 ++--
 net/appletalk/ddp.c                   |    1 +
 net/can/raw.c                         |    1 +
 net/econet/af_econet.c                |    1 +
 net/irda/af_irda.c                    |    1 +
 net/llc/af_llc.c                      |    1 +
 net/netrom/af_netrom.c                |    1 +
 net/rose/af_rose.c                    |    1 +
 net/sunrpc/clnt.c                     |    1 +
 net/sunrpc/xprt.c                     |    6 +-
 net/sunrpc/xprtsock.c                 |   37 ++++++++-
 sound/core/pcm_lib.c                  |   39 ++-------
 sound/pci/hda/patch_realtek.c         |   36 +++++---
 virt/kvm/kvm_main.c                   |   57 ++++++++-----
 48 files changed, 362 insertions(+), 307 deletions(-)
