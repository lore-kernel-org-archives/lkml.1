Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbYD2Sut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbYD2Sut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757838AbYD2Sue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:50:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:51435 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760020AbYD2Suc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:50:32 -0400
Date: Tue, 29 Apr 2008 11:49:11 -0700
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
Subject: [00/12] 2.6.24-stable review
Message-ID: <20080429184911.GA24199@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.24-stable release.
There are 12 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Thursday, May 1 16:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.24.6-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team


------------------------

 Makefile                              |    2 +-
 arch/x86/kernel/io_apic_32.c          |    1 +
 drivers/isdn/capi/capidrv.c           |    9 +++++----
 drivers/isdn/i4l/isdn_net.c           |    1 +
 drivers/media/video/cx88/cx88-cards.c |    4 ++++
 drivers/media/video/ivtv/ivtv-ioctl.c |    3 ++-
 drivers/net/tehuti.c                  |   15 +++++++++++++++
 drivers/usb/gadget/ether.c            |    1 +
 drivers/usb/serial/usb-serial.c       |    2 ++
 fs/jffs2/erase.c                      |   18 ++++++++----------
 fs/splice.c                           |    2 +-
 include/net/tcp.h                     |    7 +++++--
 12 files changed, 46 insertions(+), 19 deletions(-)
