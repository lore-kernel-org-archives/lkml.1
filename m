Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbYJFXVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbYJFXVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbYJFXVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:21:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:54907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686AbYJFXVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:21:20 -0400
Date: Mon, 6 Oct 2008 16:16:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 00/28] 2.6.25-stable review
Message-ID: <20081006231639.GA20567@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.25.18 release.
There are @num@ patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Wed Oct 8, 22:00:00 UTC.  Anything received
after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.18-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team

-------------------

 Makefile                         |    2 
 arch/x86/kernel/hpet.c           |   19 ++++--
 arch/x86/kernel/io_delay.c       |    8 ++
 arch/x86/kernel/vmi_32.c         |    2 
 drivers/acpi/ec.c                |    2 
 drivers/acpi/processor_perflib.c |    2 
 drivers/i2c/i2c-dev.c            |    4 +
 drivers/mmc/card/block.c         |    4 +
 drivers/net/niu.c                |   56 ++++++++++++++++++
 drivers/spi/pxa2xx_spi.c         |  116 ++++++++++++++++++++++++++++++---------
 drivers/usb/core/hcd.c           |    3 -
 include/asm-generic/rtc.h        |   12 +---
 include/linux/clockchips.h       |    2 
 include/net/netlink.h            |    2 
 kernel/time/clockevents.c        |    3 -
 kernel/time/ntp.c                |    2 
 kernel/time/tick-broadcast.c     |   78 +++++++++++++++++++-------
 kernel/time/tick-common.c        |    1 
 kernel/time/tick-internal.h      |    2 
 kernel/time/tick-oneshot.c       |   44 ++++++++++++--
 net/ipv4/udp.c                   |   57 +++++++++++--------
 net/ipv6/ip6_output.c            |   64 ++++++++++-----------
 net/ipv6/udp.c                   |    6 +-
 net/sctp/associola.c             |    9 +--
 net/sctp/sm_make_chunk.c         |   15 +++--
 sound/pci/hda/patch_sigmatel.c   |    2 
 26 files changed, 372 insertions(+), 145 deletions(-)
