Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbYFWXHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbYFWXHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYFWXHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:07:01 -0400
Received: from ns1.suse.de ([195.135.220.2]:44430 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbYFWXHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:07:00 -0400
Date: Mon, 23 Jun 2008 16:04:17 -0700
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
Subject: [patch 00/10] 2.6.28.9-rc2 review
Message-ID: <20080623230417.GA29853@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As -rc1 had a number of issues, here's the set of patches for -rc2.

Responses should be made by Tuesday, June 24, 18:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
        kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.9-rc2.gz
and the diffstat can be found below.


thanks,

greg k-h

 Makefile                   |    2 
 arch/powerpc/kernel/vdso.c |    2 
 arch/x86/kernel/setup_32.c |   10 ++
 drivers/hwmon/adt7473.c    |    3 
 drivers/hwmon/lm85.c       |    2 
 drivers/net/atl1/atl1_hw.c |    1 
 drivers/watchdog/hpwdt.c   |  154 +++++++++++++++++++++++----------------------
 include/asm-x86/page_32.h  |    3 
 include/linux/bootmem.h    |    2 
 mm/bootmem.c               |    4 -
 mm/memory.c                |   41 +++++++++--
 mm/migrate.c               |   10 ++
 net/sctp/socket.c          |    4 -
 13 files changed, 145 insertions(+), 93 deletions(-)
