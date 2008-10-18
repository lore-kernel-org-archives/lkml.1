Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbYJRTJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbYJRTJo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbYJRTDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:03:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:47434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbYJRTDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:03:51 -0400
Date: Sat, 18 Oct 2008 11:36:22 -0700
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
Subject: Re: [patch 00/17] 2.6.27-stable review
Message-ID: <20081018183622.GA21317@suse.de>
References: <20081018183334.GA14035@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081018183334.GA14035@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 11:33:34AM -0700, Greg KH wrote:
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.3-rc1.gz
> and the diffstat can be found below.

Oops, forgot it, here it is.

 Documentation/video4linux/CARDLIST.au0828 |    2 
 Makefile                                  |    2 
 drivers/base/core.c                       |   25 ++++++--
 drivers/gpu/drm/i915/i915_dma.c           |    2 
 drivers/md/md.c                           |    6 --
 drivers/media/dvb/siano/sms-cards.c       |    4 +
 drivers/media/video/au0828/au0828-cards.c |    3 +
 drivers/net/wireless/ath9k/core.h         |    2 
 drivers/net/wireless/ath9k/main.c         |    8 ++
 drivers/usb/core/hcd.c                    |    4 +
 drivers/usb/core/hcd.h                    |    6 ++
 drivers/usb/gadget/s3c2410_udc.c          |    2 
 drivers/usb/gadget/u_ether.c              |    7 ++
 drivers/usb/host/ehci-hcd.c               |   15 ++++-
 drivers/usb/host/ohci-hcd.c               |    3 +
 drivers/usb/host/ohci-hub.c               |   87 +++++++++++++++++-------------
 drivers/usb/host/uhci-hcd.c               |    3 +
 drivers/usb/musb/Kconfig                  |    4 -
 drivers/usb/musb/cppi_dma.h               |    4 -
 drivers/usb/musb/davinci.c                |   20 +-----
 drivers/usb/musb/musb_core.c              |    8 +-
 drivers/usb/musb/musb_host.c              |    6 +-
 drivers/video/console/fbcon.c             |    4 -
 fs/xfs/linux-2.6/xfs_super.c              |    2 
 kernel/module.c                           |    2 
 net/mac80211/wext.c                       |    2 
 26 files changed, 146 insertions(+), 87 deletions(-)
