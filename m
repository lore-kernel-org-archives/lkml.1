Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbYKGXXC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbYKGXXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:23:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYKGXWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:22:49 -0500
Received: from kroah.org ([198.145.64.141]:59108 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752305AbYKGXWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:22:48 -0500
Date: Fri, 7 Nov 2008 15:14:57 -0800
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
Subject: [patch 00/23] 2.6.26.8-stable review
Message-ID: <20081107231457.GA1108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.26.8 release.
There are 23 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Monday, November 10, 20:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.26.8-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

----------------

 Makefile                                       |    2 
 arch/sparc64/kernel/trampoline.S               |   18 ++-
 drivers/acpi/button.c                          |    3 
 drivers/acpi/dock.c                            |    5 -
 drivers/acpi/video.c                           |  123 ++++++++++++++-----------
 drivers/edac/cell_edac.c                       |    2 
 drivers/gpio/gpiolib.c                         |    2 
 drivers/i2c/busses/scx200_i2c.c                |    1 
 drivers/media/dvb/frontends/s5h1411.c          |   35 +++++--
 drivers/media/video/pvrusb2/pvrusb2-encoder.c  |    4 
 drivers/net/wireless/libertas/scan.c           |    4 
 drivers/scsi/qla2xxx/qla_gs.c                  |    6 +
 fs/ext2/dir.c                                  |   60 +++++++-----
 fs/ext3/dir.c                                  |   10 +-
 fs/ext4/dir.c                                  |   11 +-
 include/linux/sched.h                          |    4 
 include/math-emu/op-common.h                   |   17 ++-
 include/net/scm.h                              |    5 -
 net/core/dev.c                                 |   27 +----
 net/core/rtnetlink.c                           |    2 
 net/core/scm.c                                 |   24 ++++
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 
 net/ipv4/netfilter/nf_nat_snmp_basic.c         |    1 
 net/ipv6/tcp_ipv6.c                            |    2 
 net/netfilter/xt_iprange.c                     |    8 -
 security/commoncap.c                           |    6 -
 sound/core/control.c                           |    4 
 27 files changed, 247 insertions(+), 141 deletions(-)
