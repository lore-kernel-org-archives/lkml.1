Return-Path: <linux-kernel-owner+w=401wt.eu-S1765595AbYCFCX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765595AbYCFCX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYCFCXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:23:15 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:46954 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752248AbYCFCXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:23:14 -0500
Date: Thu, 6 Mar 2008 11:22:56 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <adrian.bunk@movial.fi>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] sh_ksyms_32.c update for gcc 4.3
Message-ID: <20080306022256.GC31163@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <adrian.bunk@movial.fi>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080304223958.GA2136@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304223958.GA2136@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 12:39:58AM +0200, Adrian Bunk wrote:
> This patch fixes the following build error with landisk_defconfig when 
> using gcc 4.3:
> 
> <--  snip  -->
> 
> ...
>   MODPOST 50 modules
> ERROR: "__udivsi3_i4i" [net/sunrpc/sunrpc.ko] undefined!
> ERROR: "__udivsi3_i4i" [net/appletalk/appletalk.ko] undefined!
> ERROR: "__udivsi3_i4i" [fs/ufs/ufs.ko] undefined!
> ERROR: "__udivsi3_i4i" [fs/ntfs/ntfs.ko] undefined!
> ERROR: "__sdivsi3_i4i" [fs/ntfs/ntfs.ko] undefined!
> ERROR: "__udivsi3_i4i" [fs/nfsd/nfsd.ko] undefined!
> ERROR: "__sdivsi3_i4i" [fs/nfsd/nfsd.ko] undefined!
> ERROR: "__udivsi3_i4i" [fs/nfs/nfs.ko] undefined!
> ERROR: "__udivsi3_i4i" [fs/lockd/lockd.ko] undefined!
> ERROR: "__udivsi3_i4i" [drivers/usb/storage/usb-storage.ko] undefined!
> ERROR: "__sdivsi3_i4i" [drivers/usb/serial/pl2303.ko] undefined!
> ERROR: "__udivsi3_i4i" [drivers/usb/serial/pl2303.ko] undefined!
> ERROR: "__sdivsi3_i4i" [drivers/usb/serial/ftdi_sio.ko] undefined!
> ERROR: "__udivsi3_i4i" [drivers/usb/misc/sisusbvga/sisusbvga.ko] undefined!
> ERROR: "__sdivsi3_i4i" [drivers/usb/misc/sisusbvga/sisusbvga.ko] undefined!
> ERROR: "__udivsi3_i4i" [drivers/media/video/v4l1-compat.ko] undefined!
> ERROR: "__sdivsi3_i4i" [drivers/media/video/v4l1-compat.ko] undefined!
> ERROR: "__sdivsi3_i4i" [drivers/media/video/usbvideo/vicam.ko] undefined!
> ERROR: "__udivsi3_i4i" [drivers/media/video/usbvideo/usbvideo.ko] undefined!
> ERROR: "__sdivsi3_i4i" [drivers/media/video/usbvideo/usbvideo.ko] undefined!
> ERROR: "__udivsi3_i4i" [drivers/media/video/sn9c102/sn9c102.ko] undefined!
> ERROR: "__sdivsi3_i4i" [drivers/media/video/sn9c102/sn9c102.ko] undefined!
> ERROR: "__sdivsi3_i4i" [drivers/media/video/se401.ko] undefined!
> ERROR: "__sdivsi3_i4i" [drivers/media/video/pwc/pwc.ko] undefined!
> ERROR: "__udivsi3_i4i" [drivers/md/raid0.ko] undefined!
> ERROR: "__udivsi3_i4i" [drivers/md/md-mod.ko] undefined!
> ERROR: "__sdivsi3_i4i" [drivers/md/md-mod.ko] undefined!
> ERROR: "__udivsi3_i4i" [drivers/md/linear.ko] undefined!
> ERROR: "__sdivsi3_i4i" [drivers/hid/usbhid/usbhid.ko] undefined!
> make[2]: *** [__modpost] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
> 
Applied, thanks.
