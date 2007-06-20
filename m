Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbXFTORB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbXFTORB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 10:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXFTOQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 10:16:54 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:31503 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbXFTOQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 10:16:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f1bp7iIapIkqxjJN9IC9fo1UNXwD+UwhwXs9RtOwL6IGjgf9IALIRM1R9iEeANxHj10rIhRtB+9b7LXzqf8nYoCP5QcWVrmC2+O+A4JAOXyO867ckP68AMoGAYiLYabJSs+OP4qJZQpMg7AosgHFR4OwAaCLLT7wqK4sWTZSBrY=
Message-ID: <cda58cb80706200716g6de08bb5hdbe408888abf3de4@mail.gmail.com>
Date: Wed, 20 Jun 2007 16:16:51 +0200
From: "Franck Bui-Huu" <vagabon.xyz@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [2.6 patch] more MOMENCO_JAGUAR_ATX removal
Cc: "Ralf Baechle" <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070619202704.GG12950@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070619202704.GG12950@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6/19/07, Adrian Bunk <bunk@stusta.de> wrote:
> This patch removes the few leftovers of the MOMENCO_JAGUAR_ATX removal.
>

thanks for catching it,

> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>
> ---
>
>  drivers/net/Kconfig    |    2 +-
>  include/asm-mips/war.h |    7 +++----
>  2 files changed, 4 insertions(+), 5 deletions(-)
>
> --- linux-2.6.22-rc4-mm2/drivers/net/Kconfig.old        2007-06-18 15:24:49.000000000 +0200
> +++ linux-2.6.22-rc4-mm2/drivers/net/Kconfig    2007-06-18 15:25:02.000000000 +0200
> @@ -2362,7 +2362,7 @@
>
>  config MV643XX_ETH
>         tristate "MV-643XX Ethernet support"
> -       depends on MOMENCO_OCELOT_C || MOMENCO_JAGUAR_ATX || MV64360 || MV64X60 || MOMENCO_OCELOT_3 || (PPC_MULTIPLATFORM && PPC32)
> +       depends on MOMENCO_OCELOT_C || MV64360 || MV64X60 || MOMENCO_OCELOT_3 || (PPC_MULTIPLATFORM && PPC32)

Actually MOMENCO_OCELOT_C has been killed too...

-- 
               Franck
