Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbYJRTTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbYJRTTl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYJRTFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:05:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:38712 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbYJRTFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:05:51 -0400
Date: Sat, 18 Oct 2008 11:56:58 -0700
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
Subject: [patch 00/14] 2.6.25-stable review
Message-ID: <20081018185658.GA17196@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.25.19 release.
There are 14 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Wed, October 22, 2008 19:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.19-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

----------

 Makefile                                |    2 
 arch/x86/kernel/alternative.c           |    2 
 arch/x86/kernel/cpu/mtrr/generic.c      |    7 +
 arch/x86/kernel/io_apic_32.c            |    3 
 arch/x86/mm/ioremap.c                   |    2 
 drivers/char/drm/i915_dma.c             |    2 
 drivers/char/tty_io.c                   |    2 
 drivers/hwmon/it87.c                    |   39 ++++++++-
 drivers/media/video/bt8xx/bttv-driver.c |    2 
 drivers/media/video/zoran_driver.c      |    2 
 drivers/net/wireless/b43legacy/xmit.c   |    2 
 drivers/video/console/fbcon.c           |    4 -
 fs/cifs/cifsglob.h                      |    1 
 fs/cifs/cifssmb.c                       |    4 +
 fs/cifs/readdir.c                       |  128 ++++++++++++++++----------------
 fs/splice.c                             |    3 
 kernel/sched_rt.c                       |    8 +-
 17 files changed, 129 insertions(+), 84 deletions(-)
