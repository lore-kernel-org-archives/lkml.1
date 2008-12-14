Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbYLNTVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbYLNTVa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 14:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYLNTVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 14:21:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:23425 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbYLNTVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 14:21:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,219,1228118400"; 
   d="scan'208";a="90056619"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: Tree for December 12 (drm)
Date: Sun, 14 Dec 2008 11:21:13 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "airlied@linux.ie" <airlied@linux.ie>
References: <20081212185654.0af8b4a1.sfr@canb.auug.org.au> <4943405A.4080009@xenotime.net>
In-Reply-To: <4943405A.4080009@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812141121.14400.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 12, 2008 8:55 pm Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> >
> > Changes since 20081211:
> >
> > Undropped tree:
> > 	drm
>
> oops    ^^^
>
>
> When I2C=n, and drm is built-in or modular, this build error
> happens:
>
> (drm built-in:)
>
> build-r7079.out:(.text+0x47e5f): undefined reference to `i2c_transfer'
> 7080	same
> 7086	same
> 7089	same
> (from gpu/drm/drm_edid.c)
>
>
> (drm modular:)
>
> build-r7103.out:ERROR: "i2c_transfer" [drivers/gpu/drm/drm.ko] undefined!
> (from gpu/drm/drm_edid.c)

Looks like Dave pushed a fix for this by making DRM select the required I2C 
bits.  Dunno that or depends is preferred these days though...

-- 
Jesse Barnes, Intel Open Source Technology Center

