Return-Path: <linux-kernel-owner+w=401wt.eu-S1764149AbYHDVbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764149AbYHDVbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761977AbYHDVaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:30:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763944AbYHDVaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:30:04 -0400
Date: Mon, 4 Aug 2008 14:27:25 -0700
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
Subject: [patch 00/25] 2.6.26-stable review
Message-ID: <20080804212725.GA7944@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.26.2 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Wed, August 6, 12:00:00 UTC.  Anything
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.26.2-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team

--------------

 Documentation/ftrace.txt              | 1353 ----------------------------------
 Makefile                              |    2 
 arch/powerpc/kernel/ppc32.h           |    2 
 arch/powerpc/kernel/ptrace32.c        |   27 
 arch/x86/kernel/io_delay.c            |    3 
 arch/x86/kernel/kprobes.c             |    1 
 arch/x86/kernel/process.c             |    3 
 block/bsg.c                           |    9 
 drivers/input/serio/i8042-x86ia64io.h |   43 -
 drivers/md/linear.c                   |    2 
 drivers/md/md.c                       |    2 
 drivers/net/wireless/ath5k/base.c     |   35 
 drivers/net/wireless/ath5k/base.h     |    2 
 drivers/scsi/ch.c                     |    1 
 fs/jbd/transaction.c                  |   57 +
 fs/namei.c                            |   19 
 fs/nfs/inode.c                        |    4 
 fs/nfs/internal.h                     |    1 
 fs/nfs/nfs3acl.c                      |    9 
 fs/nfs/nfs4proc.c                     |    5 
 fs/romfs/inode.c                      |   37 
 include/sound/emu10k1.h               |    1 
 mm/filemap.c                          |    3 
 net/bluetooth/bnep/core.c             |    5 
 net/bluetooth/hidp/core.c             |   10 
 net/ipv4/netfilter/nf_nat_sip.c       |   38 
 net/netfilter/xt_time.c               |    2 
 sound/pci/emu10k1/emu10k1_main.c      |    1 
 sound/pci/emu10k1/emumixer.c          |   13 
 sound/pci/hda/hda_intel.c             |  124 ++-
 sound/pci/hda/patch_analog.c          |   33 
 31 files changed, 395 insertions(+), 1452 deletions(-)
