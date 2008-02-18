Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbYBRSLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbYBRSLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 13:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYBRSL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 13:11:29 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:50762 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYBRSL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 13:11:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: [PATCH] [SSB] PCI core driver: use new SPROM data structure
Date: Mon, 18 Feb 2008 19:10:46 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Adrian Bunk <bunk@kernel.org>, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>, ralf@linux-mips.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
References: <20080217200947.GH1403@cs181133002.pp.htv.fi> <20080218100126.GA22519@hall.aurel32.net> <20080218100257.GB22519@hall.aurel32.net>
In-Reply-To: <20080218100257.GB22519@hall.aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802181910.46581.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2008 11:02:57 Aurelien Jarno wrote:
> Switch the SSB PCI core driver to the new SPROM data structure now that
> the old one has been removed.
> 
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>

Acked-by: Michael Buesch <mb@bu3sch.de>

John, can you please apply this?

> ---
>  drivers/ssb/driver_pcicore.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
> index 2faaa90..191db7a 100644
> --- a/drivers/ssb/driver_pcicore.c
> +++ b/drivers/ssb/driver_pcicore.c
> @@ -362,7 +362,7 @@ static int pcicore_is_in_hostmode(struct ssb_pcicore *pc)
>  	    chipid_top != 0x5300)
>  		return 0;
>  
> -	if (bus->sprom.r1.boardflags_lo & SSB_PCICORE_BFL_NOPCI)
> +	if (bus->sprom.boardflags_lo & SSB_PCICORE_BFL_NOPCI)
>  		return 0;
>  
>  	/* The 200-pin BCM4712 package does not bond out PCI. Even when
> -- 
> 1.5.4.1
> 



-- 
Greetings Michael.
