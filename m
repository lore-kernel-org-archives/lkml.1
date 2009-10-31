Return-Path: <linux-kernel-owner+w=401wt.eu-S933187AbZJaTXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbZJaTXu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 15:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933147AbZJaTXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 15:23:49 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:61923 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbZJaTXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 15:23:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TAWpbYCPFb//hkT7X6/AlfAbvLh9XqWrW4geHE1kisPwovLgceeX5yiGPZPWPKbkYh
         rLDW5GdSH2IO1r5YvhHw2Kb7YEziTuNXqmvP8cuMwh7zziLRAWZf5SGj+OQNXSPzvyTN
         eBic5QED2/RRRjad6bbx6AZC1emvSxzuoWsr8=
MIME-Version: 1.0
In-Reply-To: <b8bf37780910310102x6ee7bb36ic149e17f81406a1@mail.gmail.com>
References: <b8bf37780910310102x6ee7bb36ic149e17f81406a1@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 31 Oct 2009 15:23:34 -0400
Message-ID: <8bd0f97a0910311223i11a7433ds501b23602b419f3b@mail.gmail.com>
Subject: Re: [PATCH] blackfin: fix typo on using CONFIG_BFIN_EXTMEM_WRITETHROUGH 
	kconfig definition
To: =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>
Cc: cooloney@kernel.org, graf.yang@analog.com, bernds_cb1@t-online.de,
       robin.getz@analog.com, uclinux-dist-devel@blackfin.uclinux.org,
       linux list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 31, 2009 at 04:02, André Goddard Rosa wrote:
> --- a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
> +++ b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
> @@ -38,7 +38,7 @@ void __init generate_cplb_tables_cpu(unsigned int cpu)
>
>  #ifdef CONFIG_BFIN_EXTMEM_DCACHEABLE
>        d_cache = CPLB_L1_CHBL;
> -#ifdef CONFIG_BFIN_EXTMEM_WRITETROUGH
> +#ifdef CONFIG_BFIN_EXTMEM_WRITETHROUGH
>        d_cache |= CPLB_L1_AOW | CPLB_WT;
>  #endif
>  #endif

a quick glance looks good to me.  i'll merge into the blackfin tree in a bit.
-mike
