Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbYFVTE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbYFVTE6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbYFVTEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:04:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:39891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702AbYFVTEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:04:41 -0400
Date: Sun, 22 Jun 2008 12:01:11 -0700
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
Subject: [patch 0/5] 2.6.25-stable review
Message-ID: <20080622190111.GA20141@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.25.9 release.
There are 5 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Tuesday, June 24, 18:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.9-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team

 Makefile                   |    2 +-
 arch/powerpc/kernel/vdso.c |    2 +-
 arch/x86/kernel/setup_32.c |   10 ++++++++--
 drivers/net/atl1/atl1_hw.c |    1 -
 include/asm-x86/page_32.h  |    3 ++-
 mm/memory.c                |   17 +++++++++++++----
 mm/migrate.c               |   10 ++++++++++
 net/sctp/socket.c          |    4 +++-
 8 files changed, 38 insertions(+), 11 deletions(-)
