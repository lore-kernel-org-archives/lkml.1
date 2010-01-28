Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212Ab0A1W6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab0A1W6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 17:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456Ab0A1W6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 17:58:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:56861 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab0A1W6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 17:58:40 -0500
Date: Thu, 28 Jan 2010 23:58:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tree-wide: trivial typo fixes: s/lenght/length/g
In-Reply-To: <1264664231-28338-1-git-send-email-daniel@caiaq.de>
Message-ID: <alpine.LNX.2.00.1001282357190.356@pobox.suse.cz>
References: <1264664231-28338-1-git-send-email-daniel@caiaq.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jan 2010, Daniel Mack wrote:

> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Jiri Kosina <trivial@kernel.org>
> ---
>  arch/arm/mach-at91/include/mach/at91_mci.h  |    2 +-
>  arch/s390/crypto/sha_common.c               |    2 +-
>  drivers/crypto/hifn_795x.c                  |    2 +-
>  drivers/isdn/mISDN/l1oip_core.c             |    2 +-
>  drivers/net/ppp_generic.c                   |    2 +-
>  drivers/net/r6040.c                         |    2 +-
>  drivers/net/stmmac/common.h                 |    2 +-
>  drivers/net/stmmac/gmac.c                   |    4 ++--
>  drivers/net/stmmac/mac100.c                 |    2 +-
>  drivers/net/stmmac/stmmac_ethtool.c         |    2 +-
>  drivers/net/wimax/i2400m/i2400m-usb.h       |    2 +-
>  drivers/net/wireless/p54/p54spi.c           |    2 +-
>  drivers/net/wireless/wl12xx/wl1251_cmd.c    |    2 +-
>  drivers/net/wireless/wl12xx/wl1251_rx.c     |    2 +-
>  drivers/net/wireless/wl12xx/wl1271_cmd.c    |    2 +-
>  drivers/staging/comedi/drivers/usbdux.c     |    2 +-
>  drivers/staging/comedi/drivers/usbduxfast.c |    2 +-
>  drivers/staging/dream/camera/msm_camera.c   |    2 +-
>  drivers/staging/rt2860/common/cmm_sanity.c  |    4 ++--
>  drivers/staging/rt2860/common/cmm_wpa.c     |    2 +-
>  drivers/staging/rt2860/rt_linux.c           |    2 +-
>  drivers/staging/rt2860/sta/rtmp_data.c      |    2 +-
>  drivers/staging/rtl8187se/r8180_core.c      |    2 +-
>  drivers/staging/wlags49_h2/hcf.c            |    2 +-
>  drivers/staging/wlags49_h2/wl_util.c        |    4 ++--
>  drivers/usb/wusbcore/wusbhc.h               |    2 +-
>  drivers/uwb/uwbd.c                          |    2 +-
>  fs/cifs/asn1.c                              |    2 +-
>  fs/ext4/mballoc.c                           |    2 +-
>  fs/udf/inode.c                              |    2 +-
>  kernel/trace/trace.h                        |    2 +-
>  net/dccp/ackvec.h                           |    2 +-
>  32 files changed, 35 insertions(+), 35 deletions(-)

Please take out the drivers/staging part and push that one individually to 
Greg. I'll then merge the remaining bits through my tree.

The code in staging tree is supposed to be changing rapidly, so we'll be
getting conflicts in linux-next very often.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
