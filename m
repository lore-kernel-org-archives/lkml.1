Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141Ab0ADNoC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab0ADNoC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 08:44:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094Ab0ADNn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 08:43:58 -0500
Received: from mga06.intel.com ([134.134.136.21]:20966 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751883Ab0ADNn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 08:43:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,498,1257148800"; 
   d="scan'208";a="481077003"
Date: Mon, 4 Jan 2010 14:45:38 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       SH-Linux <linux-sh@vger.kernel.org>, Ian Molton <ian@mnementh.co.uk>
Subject: Re: v2.6.33-rc2 build error - missing tmio mmc patches
Message-ID: <20100104134537.GA5394@sortiz.org>
References: <aec7e5c30912280011j4e8528e5r34bc1bcfb6a4dd1a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c30912280011j4e8528e5r34bc1bcfb6a4dd1a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Mon, Dec 28, 2009 at 05:11:27PM +0900, Magnus Damm wrote:
> Hi everyone,
> 
> v2.6.33-rc2 does not build in the case of CONFIG_MFD_SH_MOBILE_SDHI=y.
> Linux-next used to build just fine when I developed the driver, but
> now it looks like some tmio-mmc patches present in linux-next never
> made it into -rc.
> 
>   CC      drivers/mfd/sh_mobile_sdhi.o
> drivers/mfd/sh_mobile_sdhi.c: In function 'sh_mobile_sdhi_probe':
> drivers/mfd/sh_mobile_sdhi.c:100: error: 'struct tmio_mmc_data' has no
> member named 'set_pwr'
> make[2]: *** [drivers/mfd/sh_mobile_sdhi.o] Error 1
> 
> In more detail, the missing patch is here:
> http://git.mnementh.co.uk/cgi-bin/gitweb.cgi?p=linux-2.6-im.git;a=commitdiff;h=4cd83bd05e6c817a4a72ababd82bf5ae700c021d
> 
> What needs to be done to get the patch above included in rc3? Is there
> anything I can do?
Ian assumed anything that was in linux-next was being pulled by Linus
automatically. That's why this code is not there.
Could you or Ian please submit this patch to linux-kernel and me. If it's all
fine, I'll carry it with my next .33 fixes.

Cheers,
Samuel.


> Thanks,
> 
> / magnus

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
