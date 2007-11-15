Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbXKOGmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbXKOGmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXKOGmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:42:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55062 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbXKOGmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:42:31 -0500
Date: Wed, 14 Nov 2007 22:39:21 -0800
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
Subject: [patch 00/16] 2.6.23-stable review, network driver changes
Message-ID: <20071115063921.GA18827@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.23.X release.
There are 16 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday 00:00:00 UTC.  Anything received
after that time might be too late.

This set of patches focuses on only networking drivers.

The diffstat of this review series is included below.

thanks,

greg k-h

-----

 drivers/net/ehea/ehea_qmr.c            |   20 +---
 drivers/net/ehea/ehea_qmr.h            |    2 
 drivers/net/forcedeth.c                |   35 ++++++--
 drivers/net/pppol2tp.c                 |   25 ++++-
 drivers/net/skge.c                     |  141 +++++++++++++++++----------------
 drivers/net/skge.h                     |    6 -
 drivers/net/sky2.c                     |   87 ++++++++++++++++----
 drivers/net/tg3.c                      |   10 +-
 drivers/net/wireless/ipw2100.c         |   39 +++++++++
 drivers/net/wireless/ipw2100.h         |    4 
 drivers/net/wireless/libertas/11d.c    |    2 
 drivers/net/wireless/libertas/cmd.c    |    6 -
 drivers/net/wireless/libertas/wext.c   |    8 -
 drivers/net/wireless/rtl8187_dev.c     |   31 +++----
 drivers/net/wireless/zd1201.c          |    4 
 drivers/net/wireless/zd1211rw/zd_usb.c |    7 +
 include/linux/pci_ids.h                |    4 
 17 files changed, 283 insertions(+), 148 deletions(-)
