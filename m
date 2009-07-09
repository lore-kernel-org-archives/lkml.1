Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbZGIO2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbZGIO2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760949AbZGIO2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:28:01 -0400
Received: from mail-pz0-f175.google.com ([209.85.222.175]:53971 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760954AbZGIO2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:28:00 -0400
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/44] includecheck fix: arm, board-dm646x-evm.c
References: <1247063308.4382.12.camel@ht.satnam>
	<1247063802.4382.23.camel@ht.satnam>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 09 Jul 2009 07:27:57 -0700
In-Reply-To: <1247063802.4382.23.camel@ht.satnam> (Jaswinder Singh Rajput's message of "Wed\, 08 Jul 2009 20\:06\:42 +0530")
Message-ID: <87ab3ex76a.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput <jaswinder@kernel.org> writes:

> fix the following 'make includecheck' warning:
>
>   arch/arm/mach-davinci/board-dm646x-evm.c: mach/common.h is included more than once.
>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Acked-by: Kevin Hilman <khilman@deeprootsystems.com>

> ---
>  arch/arm/mach-davinci/board-dm646x-evm.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
> index e17de63..8657e72 100644
> --- a/arch/arm/mach-davinci/board-dm646x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm646x-evm.c
> @@ -47,7 +47,6 @@
>  #include <mach/i2c.h>
>  #include <mach/mmc.h>
>  #include <mach/emac.h>
> -#include <mach/common.h>
>  
>  #define DM646X_EVM_PHY_MASK		(0x2)
>  #define DM646X_EVM_MDIO_FREQUENCY	(2200000) /* PHY bus frequency */
> -- 
> 1.6.0.6
