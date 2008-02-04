Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbYBDCwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbYBDCwV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 21:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYBDCwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 21:52:11 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:1841 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYBDCwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 21:52:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=muRg6t9tnTA/77Pfe9FwMpgGRuqgiUpwXEG74z3U/Ha4/9ZbkpgiBJSQ4w3NQ8yW5H0JW6Rx2zaj+wPD0UgUlpw/n5kgQCvfQ7U9tCAW3OdGVgXLZ0AoKs9JNQlWNndeQnfSESyVIaQnT/IurET0oxy3EcMqv2OLsjCAQ9NDvm0=
Message-ID: <86802c440802031852m2f5b758g4d0a5a784621f417@mail.gmail.com>
Date: Sun, 3 Feb 2008 18:52:08 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Yinghai Lu" <Yinghai.Lu@sun.com>
Subject: Re: about x86: relax RAM check in ioremap
Cc: "Ingo Molnar" <mingo@elte.hu>, kjwinchester@gmail.com,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <200802031538.14213.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802031538.14213.yinghai.lu@sun.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 3, 2008 3:38 PM, Yinghai Lu <Yinghai.Lu@sun.com> wrote:
> wonder if you still need that patch after following patch is a applied.
>
> YH
>
> diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> index 608152a..f645413 100644
> --- a/arch/x86/kernel/aperture_64.c
> +++ b/arch/x86/kernel/aperture_64.c
> @@ -278,7 +278,7 @@ void __init early_gart_iommu_check(void)
>                 last_aper_enabled = aper_enabled;
>         }
>
> -       if (!fix && !aper_enabled)
> +       if (!fix /* && !aper_enabled*/)
>                 return;
>
>         if (!aper_base || !aper_size || aper_base + aper_size > 0x100000000UL)
> --

forget about it, it seem kevin is using 32 bit kernel.

YH
