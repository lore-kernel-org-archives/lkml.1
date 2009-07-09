Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbZGIO2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbZGIO2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761335AbZGIO22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:28:28 -0400
Received: from mail-pz0-f175.google.com ([209.85.222.175]:53971 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761289AbZGIO21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:28:27 -0400
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/44] includecheck fix: arm, board-sffsdr.c
References: <1247063308.4382.12.camel@ht.satnam>
	<1247063846.4382.24.camel@ht.satnam>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 09 Jul 2009 07:28:24 -0700
In-Reply-To: <1247063846.4382.24.camel@ht.satnam> (Jaswinder Singh Rajput's message of "Wed\, 08 Jul 2009 20\:07\:26 +0530")
Message-ID: <8763e2x75j.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput <jaswinder@kernel.org> writes:

> fix the following 'make includecheck' warning:
>
>   arch/arm/mach-davinci/board-sffsdr.c: mach/common.h is included more than once.
>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Acked-by: Kevin Hilman <khilman@deeprootsystems.com>

> ---
>  arch/arm/mach-davinci/board-sffsdr.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/board-sffsdr.c b/arch/arm/mach-davinci/board-sffsdr.c
> index 748a8e4..7acdfd8 100644
> --- a/arch/arm/mach-davinci/board-sffsdr.c
> +++ b/arch/arm/mach-davinci/board-sffsdr.c
> @@ -52,7 +52,6 @@
>  #include <mach/serial.h>
>  #include <mach/psc.h>
>  #include <mach/mux.h>
> -#include <mach/common.h>
>  
>  #define SFFSDR_PHY_MASK		(0x2)
>  #define SFFSDR_MDIO_FREQUENCY	(2200000) /* PHY bus frequency */
> -- 
> 1.6.0.6
