Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbYGAPWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbYGAPWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbYGAPV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:21:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:58144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbYGAPV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:21:56 -0400
Date: Tue, 1 Jul 2008 08:18:35 -0700
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
Subject: [patch 0/9] 2.6.25.10 -stable review
Message-ID: <20080701151835.GA3536@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.25.10 release.
There are 9 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by July 3, 15:00:00 UTC.  Anything received
after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.10-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team


 Makefile                                    |    2 
 arch/x86/kernel/i387.c                      |    4 -
 arch/x86/kernel/ptrace.c                    |   45 +++++++------
 arch/x86/kernel/smpboot_64.c                |    1 
 drivers/char/drm/i915_drv.c                 |    1 
 drivers/infiniband/hw/mthca/mthca_memfree.c |    6 +
 drivers/net/hamradio/6pack.c                |    2 
 drivers/net/hamradio/mkiss.c                |    8 +-
 drivers/net/irda/irtty-sir.c                |    4 -
 drivers/net/ppp_async.c                     |    3 
 drivers/net/ppp_synctty.c                   |    3 
 drivers/net/slip.c                          |   14 +++-
 drivers/net/wan/x25_asy.c                   |   10 ++-
 drivers/net/wireless/strip.c                |    3 
 include/asm-x86/msr.h                       |    2 
 kernel/futex.c                              |   93 +++++++++++++++++++++-------
 kernel/sched.c                              |    1 
 17 files changed, 147 insertions(+), 55 deletions(-)
