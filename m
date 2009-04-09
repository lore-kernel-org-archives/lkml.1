Return-Path: <linux-kernel-owner+w=401wt.eu-S1765658AbZDIKUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765658AbZDIKUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbZDIKUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:20:21 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52730 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965AbZDIKUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:20:20 -0400
X-Sasl-enc: XXglEesuTEu1qL9hWbGkJnF30o7rHWUikun+RR7dOEQ8 1239272418
Message-ID: <49DDCBDE.9030406@fastmail.fm>
Date: Thu, 09 Apr 2009 11:20:14 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH 39/56] powerpc: Remove void casts
References: <> <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-37-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-38-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-39-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-40-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-40-git-send-email-jwjstone@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CC]
Jack Stone wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  arch/powerpc/sysdev/fsl_soc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
> index afe8dbc..f63d668 100644
> --- a/arch/powerpc/sysdev/fsl_soc.c
> +++ b/arch/powerpc/sysdev/fsl_soc.c
> @@ -186,7 +186,7 @@ static int __init of_add_fixed_phys(void)
>  	struct fixed_phy_status status = {};
>  
>  	for_each_node_by_name(np, "ethernet") {
> -		fixed_link  = (u32 *)of_get_property(np, "fixed-link", NULL);
> +		fixed_link  = of_get_property(np, "fixed-link", NULL);
>  		if (!fixed_link)
>  			continue;
>  
>   

