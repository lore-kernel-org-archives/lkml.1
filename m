Return-Path: <linux-kernel-owner+w=401wt.eu-S932216AbXKTSjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbXKTSjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761871AbXKTSah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:30:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52197 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762672AbXKTSaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:30:35 -0500
Date: Tue, 20 Nov 2007 10:29:45 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/29] 2.6.23-stable review
Message-ID: <20071120182945.GA32333@kroah.com>
References: <20071120182248.GA28611@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 10:22:48AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 2.6.23.9 release.
> There are 29 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
> 
> I would especially like people who experienced the softlockup messages
> in their kernel logs on 2.6.23.8 to test this series to make sure that
> everything is now working properly.

And the full patch can be found at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.23.9-rc1.gz

The diffstat is below.

thanks,

greg k-h
------------------

 Makefile                           |    2 -
 arch/i386/lib/delay.c              |    3 +
 arch/i386/mm/pgtable.c             |    3 -
 arch/x86_64/kernel/entry.S         |    2 -
 arch/x86_64/kernel/time.c          |   11 ++-----
 arch/x86_64/lib/bitstr.c           |    2 -
 arch/x86_64/lib/delay.c            |   11 ++++---
 arch/x86_64/mm/pageattr.c          |    1 
 drivers/acpi/video.c               |   13 +++++++-
 drivers/ata/sata_sis.c             |   15 +++++----
 drivers/crypto/geode-aes.c         |    3 -
 drivers/dma/dmaengine.c            |   17 +++--------
 drivers/i2c/busses/i2c-pasemi.c    |    5 +++
 drivers/i2c/chips/eeprom.c         |   37 +++++++++++++++---------
 drivers/md/raid5.c                 |   16 +++++-----
 drivers/net/wireless/ipw2200.c     |   56 ++++++++++++++++++++++++++++++-------
 drivers/net/wireless/ipw2200.h     |    3 +
 drivers/oprofile/cpu_buffer.c      |    7 ++++
 drivers/oprofile/cpu_buffer.h      |    1 
 drivers/oprofile/oprofile_stats.c  |    4 ++
 drivers/usb/storage/unusual_devs.h |   14 +++++++++
 drivers/video/ps3fb.c              |    2 -
 fs/nfsd/nfs2acl.c                  |    2 -
 fs/nfsd/nfs3acl.c                  |    2 -
 fs/nfsd/nfsfh.c                    |   43 +++++++++++++++++-----------
 fs/reiserfs/stree.c                |    3 -
 include/asm-i386/system.h          |    2 -
 include/asm-x86_64/system.h        |    8 ++---
 kernel/sched_fair.c                |    2 -
 kernel/softlockup.c                |   47 +++++++++++++++++++------------
 kernel/time/ntp.c                  |    2 -
 lib/libcrc32c.c                    |    7 +---
 32 files changed, 227 insertions(+), 119 deletions(-)
