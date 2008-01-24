Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbYAXBUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbYAXBUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 20:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYAXBUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 20:20:24 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41332 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYAXBUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 20:20:23 -0500
Date: Wed, 23 Jan 2008 19:17:04 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org, sr@denx.de
Subject: Re: [PATCH][ppc] logical/bitand typo in powerpc/boot/4xx.c
Message-ID: <20080123191704.2d74073a@zod.rchland.ibm.com>
In-Reply-To: <4797C1AD.3040307@tiscali.nl>
References: <4797C1AD.3040307@tiscali.nl>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008 23:37:33 +0100
Roel Kluin <12o3l@tiscali.nl> wrote:

> logical/bitand typo
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/arch/powerpc/boot/4xx.c b/arch/powerpc/boot/4xx.c
> index ebf9e21..dcfb459 100644
> --- a/arch/powerpc/boot/4xx.c
> +++ b/arch/powerpc/boot/4xx.c
> @@ -104,7 +104,7 @@ void ibm4xx_denali_fixup_memsize(void)
>  	val = DDR_GET_VAL(val, DDR_CS_MAP, DDR_CS_MAP_SHIFT);
>  	cs = 0;
>  	while (val) {
> -		if (val && 0x1)
> +		if (val & 0x1)
>  			cs++;
>  		val = val >> 1;
>  	}

Hm, good catch.

Stefan, have you had problems with this code at all?

josh
