Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbXKLR36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbXKLR36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 12:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbXKLR3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 12:29:51 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:35280 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbXKLR3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 12:29:50 -0500
Message-ID: <47388D7B.9070106@freescale.com>
Date: Mon, 12 Nov 2007 11:29:31 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>,
       linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [PATCH] powerpc: Add EXPORT_SYMBOL for symbols required by fs_enet
 and cpm_uart
References: <47373571.3070605@scram.de>
In-Reply-To: <47373571.3070605@scram.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jochen Friedrich wrote:
> fs_enet and cpm_uart need symbols from commproc.c (for CPM1) or
> cpm2_common.c. Add EXPORT_SYMBOL for cpmp, cpm_setbrg and cpm2_immr, so
> the drivers can be compiled as modules.
> 
>  Building modules, stage 2.
>  MODPOST 5 modules
> ERROR: "cpm2_immr" [drivers/net/fs_enet/fs_enet.ko] undefined!
> ERROR: "cpmp" [drivers/net/fs_enet/fs_enet.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> Signed-off-by: Jochen Friedrich <jochen@scram.de>

Acked-by: Scott Wood <scottwood@freescale.com>
