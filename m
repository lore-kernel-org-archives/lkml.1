Return-Path: <linux-kernel-owner+w=401wt.eu-S1752306AbYFSV16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbYFSV16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbYFSV1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:27:49 -0400
Received: from ns2.suse.de ([195.135.220.15]:42442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbYFSV1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:27:49 -0400
Date: Thu, 19 Jun 2008 14:26:22 -0700
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
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [00/15] 2.6.25-stable review
Message-ID: <20080619212621.GA20267@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.25.8 release.
There are 15 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by June 21, 20:00:00 UTC.  Anything received after
that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.8-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team


 Makefile                               |    2 +-
 arch/x86/kernel/process_32.c           |   23 +++++++++++++++++++++--
 arch/x86/kernel/process_64.c           |   24 +++++++++++++++++++++---
 arch/x86/lib/copy_user_64.S            |   25 +++++++++++--------------
 arch/x86/lib/copy_user_nocache_64.S    |   25 +++++++++++--------------
 drivers/acpi/tables/tbinstal.c         |   18 +++++++-----------
 drivers/ide/pci/opti621.c              |   23 ++++-------------------
 drivers/net/virtio_net.c               |    8 +++++---
 drivers/net/wireless/b43/b43.h         |    1 -
 drivers/net/wireless/b43/dma.c         |    2 +-
 drivers/net/wireless/b43/main.c        |   16 ++++++++++------
 drivers/scsi/hosts.c                   |    5 +++--
 drivers/scsi/sr.c                      |    3 +++
 drivers/serial/8250.c                  |    4 +++-
 net/netfilter/nf_conntrack_core.c      |    3 +--
 net/netfilter/nf_conntrack_h323_main.c |   22 +++++++++++++++-------
 16 files changed, 117 insertions(+), 87 deletions(-)
