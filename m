Return-Path: <linux-kernel-owner+w=401wt.eu-S1760937AbZGIOSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760937AbZGIOSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760607AbZGIOSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:18:13 -0400
Received: from mail-pz0-f175.google.com ([209.85.222.175]:51486 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760599AbZGIOSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:18:12 -0400
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/44] includecheck fix: arm, board-dm355-evm.c
References: <1247063308.4382.12.camel@ht.satnam>
	<1247063588.4382.18.camel@ht.satnam>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 09 Jul 2009 07:18:08 -0700
In-Reply-To: <1247063588.4382.18.camel@ht.satnam> (Jaswinder Singh Rajput's message of "Wed\, 08 Jul 2009 20\:03\:08 +0530")
Message-ID: <87prcax7mn.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput <jaswinder@kernel.org> writes:

> fix the following 'make includecheck' warning:
>
>   arch/arm/mach-davinci/board-dm355-evm.c: mach/common.h is included more than once.
>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Acked-by: Kevin Hilman <khilman@deeprootsystems.com>

> ---
>  arch/arm/mach-davinci/board-dm355-evm.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
> index 5ac2f56..d6ab64c 100644
> --- a/arch/arm/mach-davinci/board-dm355-evm.c
> +++ b/arch/arm/mach-davinci/board-dm355-evm.c
> @@ -37,7 +37,6 @@
>  #include <mach/serial.h>
>  #include <mach/nand.h>
>  #include <mach/mmc.h>
> -#include <mach/common.h>
>  
>  #define DAVINCI_ASYNC_EMIF_CONTROL_BASE		0x01e10000
>  #define DAVINCI_ASYNC_EMIF_DATA_CE0_BASE	0x02000000
> -- 
> 1.6.0.6
