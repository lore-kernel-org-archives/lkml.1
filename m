Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbYICRse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbYICRse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbYICRsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:48:21 -0400
Received: from mail.suse.de ([195.135.220.2]:53504 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758643AbYICRsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:48:20 -0400
Date: Wed, 3 Sep 2008 10:32:18 -0700
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
Subject: [patch 00/16] 2.6.25-stable review
Message-ID: <20080903173218.GA10429@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.25.17 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by September 6 10:00:00 UTC.  Anything received
after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.17-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team


 Makefile                           |    2 
 arch/x86/kernel/cpu/mtrr/generic.c |   15 +++++
 crypto/authenc.c                   |   10 ++-
 drivers/net/forcedeth.c            |    4 -
 drivers/net/r8169.c                |    2 
 drivers/usb/class/cdc-acm.c        |    2 
 drivers/video/fb_defio.c           |   19 +++++++
 drivers/video/fbmem.c              |    4 +
 fs/cifs/file.c                     |    4 +
 fs/cramfs/inode.c                  |   84 ++++++++++++++------------------
 fs/nfsd/nfs4acl.c                  |    2 
 include/linux/fb.h                 |    3 +
 mm/page_alloc.c                    |    7 ++
 net/sched/sch_prio.c               |   16 ++++--
 net/sctp/auth.c                    |    7 ++
 net/sctp/endpointola.c             |    4 -
 net/sctp/socket.c                  |   96 ++++++++++++++++++++++++++++---------
 net/sunrpc/sysctl.c                |   18 +-----
 18 files changed, 198 insertions(+), 101 deletions(-)
