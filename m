Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbYBWASk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbYBWASk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYBWASa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:18:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53725 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbYBWAS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:18:29 -0500
Date: Fri, 22 Feb 2008 16:17:02 -0800
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
Subject: [patch 0/8] 2.6.23-stable review
Message-ID: <20080223001702.GA27727@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.23.17 release.
There are 8 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Tuesday, Feb 25, 2008, 00:10:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.23.17-rc1.gz
and the diffstat can be found below.

Note, this will probably be the last 2.6.23-stable release done by me,
barring any severe problems found.

thanks,

greg k-h

----------

 Makefile                                  |    2 -
 arch/powerpc/platforms/powermac/feature.c |   11 +++++++-
 arch/x86_64/mm/pageattr.c                 |    2 -
 drivers/macintosh/smu.c                   |   25 ++++++++++++++++++-
 drivers/scsi/sd.c                         |   34 ++++++++++++--------------
 fs/nfs/write.c                            |   20 +++++++++++++--
 include/asm-powerpc/pmac_feature.h        |    8 ++++++
 include/linux/ktime.h                     |    2 +
 kernel/futex.c                            |    2 -
 kernel/futex_compat.c                     |    2 -
 kernel/hrtimer.c                          |   38 ++++++++++++++++--------------
 kernel/irq/chip.c                         |   20 +++++++++++++++
 kernel/posix-timers.c                     |    8 +++---
 mm/memory.c                               |    2 +
 net/netfilter/nf_conntrack_proto_tcp.c    |   33 ++++++++++++++++++++------
 15 files changed, 154 insertions(+), 55 deletions(-)
