Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbZBMXCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbZBMXCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 18:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbZBMXCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 18:02:03 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:50353 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbZBMXCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 18:02:01 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+000+VyKeAwv10Zm2hUTY5
Date: Fri, 13 Feb 2009 15:01:56 -0800
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: OMAP: Fix omap34xx revision detection for
	ES3.1
Message-ID: <20090213230156.GM7562@atomide.com>
References: <20090206033847.31313.45612.stgit@localhost.localdomain> <20090206034513.31313.42445.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206034513.31313.42445.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [090205 19:52]:
> From: Tony Lindgren <tony@atomide.com>
> 
> Fix omap34xx revision detection for ES3.1
> 
> linux-omap source commit is 1bafdfd33cc7a2b053ca705cf8623e1ae6cd4c52.

Just for reference, this is now in the mainline kernel as 
commit 187e688d237a6df11a2d32e8ac480b6d1fbd40b9.

Tony

> Signed-off-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> ---
>  arch/arm/mach-omap2/id.c              |    6 +++++-
>  arch/arm/plat-omap/include/mach/cpu.h |    1 +
>  2 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
> index b0f8e7d..b52a02f 100644
> --- a/arch/arm/mach-omap2/id.c
> +++ b/arch/arm/mach-omap2/id.c
> @@ -172,9 +172,13 @@ void __init omap34xx_check_revision(void)
>  			omap_revision = OMAP3430_REV_ES3_0;
>  			rev_name = "ES3.0";
>  			break;
> +		case 4:
> +			omap_revision = OMAP3430_REV_ES3_1;
> +			rev_name = "ES3.1";
> +			break;
>  		default:
>  			/* Use the latest known revision as default */
> -			omap_revision = OMAP3430_REV_ES3_0;
> +			omap_revision = OMAP3430_REV_ES3_1;
>  			rev_name = "Unknown revision\n";
>  		}
>  	}
> diff --git a/arch/arm/plat-omap/include/mach/cpu.h b/arch/arm/plat-omap/include/mach/cpu.h
> index b2062f1..a8e1178 100644
> --- a/arch/arm/plat-omap/include/mach/cpu.h
> +++ b/arch/arm/plat-omap/include/mach/cpu.h
> @@ -339,6 +339,7 @@ IS_OMAP_TYPE(3430, 0x3430)
>  #define OMAP3430_REV_ES2_0	0x34301034
>  #define OMAP3430_REV_ES2_1	0x34302034
>  #define OMAP3430_REV_ES3_0	0x34303034
> +#define OMAP3430_REV_ES3_1	0x34304034
>  
>  /*
>   * omap_chip bits
> 
> 
